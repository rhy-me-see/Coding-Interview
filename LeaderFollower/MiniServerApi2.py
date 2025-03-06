from fastapi import FastAPI
import requests
import os
import time
import threading

# 配置 etcd V2 API
ETCD_HOST = "http://127.0.0.1:2379"
ETCD_KEY = "/leader"
TTL = 5  # Leader 租约时间
NODE_PORT = os.getenv("NODE_PORT", "8000")  # 端口

app = FastAPI()
is_leader = False
leader_port = None

# 选举 Leader
def elect_leader():
    global is_leader, leader_port
    try:
        # 使用 Compare-And-Swap (CAS) 选举 Leader
        response = requests.put(
            f"{ETCD_HOST}/v2/keys{ETCD_KEY}",
            data={"value": NODE_PORT, "ttl": TTL, "prevExist": "false"}
        )
        if response.status_code == 201:  # 201 Created -> 成功当选 Leader
            is_leader = True
            leader_port = NODE_PORT
            threading.Thread(target=refresh_leader, daemon=True).start()
            print(f"✅ Node {NODE_PORT} is the Leader")
        else:
            is_leader = False
            leader_port = get_leader()
            print(f"❌ Node {NODE_PORT} is a Follower, Leader is {leader_port}")
    except Exception as e:
        print(f"Error electing leader: {e}")

# 续约 Leader
def refresh_leader():
    while is_leader:
        time.sleep(TTL / 2)
        try:
            requests.put(f"{ETCD_HOST}/v2/keys{ETCD_KEY}", data={"value": NODE_PORT, "ttl": TTL})
        except:
            break  # 失败则退出，重新选举

# 获取当前 Leader
def get_leader():
    try:
        response = requests.get(f"{ETCD_HOST}/v2/keys{ETCD_KEY}")
        if response.status_code == 200:
            return response.json()["node"]["value"]
    except:
        return None
    return None

# `/hello` 端点：返回不同的响应
@app.get("/hello")
def hello():
    if is_leader:
        return {"message": "hello world"}
    return {"leader_port": leader_port or "unknown"}

# 启动时自动选举
@app.on_event("startup")
def startup_event():
    elect_leader()