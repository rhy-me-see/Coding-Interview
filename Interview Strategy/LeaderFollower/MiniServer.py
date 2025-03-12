from fastapi import FastAPI
import etcd3
import threading
import time
import os

# 配置 etcd 连接
etcd = etcd3.client(host='localhost', port=2379)
leader_key = "/election/leader"
lease_ttl = 5  # 租约时间（秒）
node_id = os.getenv("NODE_ID", "node-default")

app = FastAPI()
current_lease = None
is_leader = False

# 选举 Leader
@app.post("/elect")
def elect_leader():
    global is_leader, current_lease
    lease = etcd.lease(lease_ttl)  # 创建租约
    success, _ = etcd.transaction(
        compare=[etcd.transactions.version(leader_key) == 0],  # 如果 key 不存在
        success=[etcd.transactions.put(leader_key, node_id, lease)],  # 赋值给当前节点
        failure=[]
    )
    if success:
        is_leader = True
        current_lease = lease
        threading.Thread(target=keep_alive, args=(lease,), daemon=True).start()
        return {"status": "elected", "leader": node_id}
    return {"status": "failed", "message": "Another leader exists"}

# 续约租约
def keep_alive(lease):
    global is_leader
    while True:
        try:
            lease.refresh()
            time.sleep(lease_ttl / 2)
        except Exception:
            is_leader = False
            break

# 获取当前 Leader
@app.get("/leader")
def get_leader():
    leader = etcd.get(leader_key)[0]
    if leader:
        return {"leader": leader.decode()}
    return {"leader": "none"}

# 获取当前节点角色
@app.get("/status")
def get_status():
    return {"node": node_id, "role": "leader" if is_leader else "follower"}

# 监听 Leader 变化
def watch_leader():
    events_iterator, cancel_watch = etcd.watch_prefix(leader_key)
    for event in events_iterator:
        if isinstance(event, etcd3.events.DeleteEvent):
            print("Leader key deleted, triggering re-election...")
            is_leader = False

threading.Thread(target=watch_leader, daemon=True).start()