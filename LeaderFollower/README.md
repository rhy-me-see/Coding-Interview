
### Original Resource
[Experience 1](https://www.1point3acres.com/bbs/thread-980101-1-1.html) / [Experience 2](https://www.1point3acres.com/bbs/thread-999303-1-1.html)

## Core Component
 - 事先熟悉 etcd API，并写一个最小可用 demo。
 - 练习快速搭建 HTTP 服务器，确保不浪费时间。
 - 重点掌握 etcd 的租约和 Watcher 机制，能快速实现 Leader 选举。

### Etcd Installation & Local Debugging

```
brew install etcd # 安装etcd
curl http://localhost:2379/health # expect {"health":"true"}
```
#### Python 依赖 installation 

```
pip install fastapi uvicorn etcd3
```

Python 连接 etcd

```python
import etcd3  etcd = etcd3.client(host='127.0.0.1', port=2379) print(etcd.get('/some-key'))  # 读取 etcd 里的数据, 
# 如果 `etcd.get(...)` **不会报错**，说明 etcd 运行成功！
```

#### 启动实例
```
NODE_ID=node1 uvicorn main:app --port 8080 &
NODE_ID=node2 uvicorn main:app --port 8081 &
NODE_ID=node3 uvicorn main:app --port 8082 &
```

测试API
```
curl -X POST http://localhost:8080/elect # 选举 Leader 
curl http://localhost:8080/leader # 获取 Leader 
curl http://localhost:8080/status # 获取当前节点角色
```

#### 终止实例
```
ps aux | grep uvicorn # 找到所有相关进程
pkill -f "uvicorn main:app" # 强制终止所有进程
```