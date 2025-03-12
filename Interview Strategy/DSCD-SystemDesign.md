
#### Notes from Prep
communication is important, see it as a sound board? 
put up a solid design, also explain why we’re choosing it. 
tool → draw.io / excalidraw /

[Link for structure](https://chatgpt.com/c/67be28ab-ad2c-8005-9de7-49c36cac9c3d)
[Link for design choices](https://chatgpt.com/c/67d0a5e5-e610-8005-93b4-aa64dd24)
## Follow these steps

- **Clarify Requirements（明确需求）**
- **Define Scope & Constraints（定义范围 & 约束）**
- **High-Level Design（高层设计）**
- **Component Design（详细组件设计）**
- **Database Schema（数据库设计）**
- **Scaling Strategies（扩展性 & 高可用）**
- **Trade-offs & Optimizations（权衡和优化）**
- **Summary（总结）**

## **Step 1: Clarify Requirements（明确需求）**

✅ **功能需求**：

- 用户可以进入匹配队列，匹配到相似技能水平的玩家
- 匹配可以是 **1v1**，也可以是 **多人匹配（如5v5）**
- 低延迟匹配（如匹配应在 **几秒内** 完成）
- 需要支持跨区域匹配，避免玩家过少时匹配失败

✅ **非功能需求**：

- **高可用性**：不能有长时间宕机
- **高吞吐量**：可以支持 **每秒上千次** 匹配请求
- **低延迟**：匹配时间尽可能短
- **可扩展性**：匹配算法可以不断优化

✅ **问题确认**：

1. **Skill Level** 如何定义？基于 ELO/MMR 评分？还是其他算法？
2. 允许**跨区域**匹配吗？还是优先匹配相同地区？
3. **单人匹配** 还是**组队匹配**？
4. 允许用户**等待**匹配更合适的对手，还是必须快速匹配？


## **Step 2: Define Scope & Constraints（定义范围 & 约束）**

📌 **假设**

- 每秒有 **50,000** 个匹配请求（中大型游戏的水平）
- 匹配系统需要支持 **全球多个服务器**
- 玩家等待匹配时间尽量不超过 **10 秒**
- 每个匹配请求的数据量 **<1KB**
- 需要考虑**分布式架构**，避免单点故障


## **Step 4: Component Design（详细组件设计）**

### **1. API Gateway**

- 处理玩家匹配请求（REST API / WebSocket）
- 进行基本的 **用户身份验证**
- 负载均衡后转发给 **Matchmaking Service**

|**对比项**|**WebSocket**|**API (REST/GraphQL)**|
|---|---|---|
|**实时性**|✅ **极高**，服务器可主动推送|❌ **较低**，依赖轮询|
|**服务器开销**|❌ 需要维护长连接|✅ 无状态，易于扩展|
|**流量消耗**|✅ **更少**，只传输必要数据|❌ **更多**，多次 HTTP 请求|
|**实现复杂度**|❌ **复杂**，需管理连接、心跳、断线重连|✅ **简单**，基于标准 HTTP|
|**兼容性**|❌ 可能受防火墙/代理影响|✅ 适用于所有设备|
|**适用场景**|**高实时匹配** (FPS/MOBA)|**低实时需求匹配** (回合制/MMORPG)

### **2. Matchmaking Service**

- **核心匹配逻辑**，计算玩家匹配度
- 查询 **Skill Rating DB** 获取玩家等级
- 使用 **匹配算法**（ELO / MMR / KD比）决定匹配对象
- 把匹配成功的玩家 **推送到 Game Server**
- 如果超时未匹配到合适玩家，可能 **放宽匹配条件**

### **3. Matchmaking Queue**

- 一个**优先队列（Priority Queue）**，按照 **Skill Level** 组织玩家
- 先进的玩家优先匹配
- 可能使用 **Redis / Kafka** 实现

### **4. Skill Rating DB**

- 存储玩家的 **Skill Level**（ELO/MMR/KD等）
- 可能使用 **PostgreSQL / DynamoDB / Redis**

### **5. Game Server**

- 匹配成功后，**通知游戏服务器** 创建房间
- 维护玩家的 **对战状态**

## **Step 5: Database Schema（数据库设计）**

使用 **PostgreSQL / DynamoDB** 进行存储：

```sql
CREATE TABLE players (    
player_id VARCHAR PRIMARY KEY,     
skill_rating INT,     
region VARCHAR,     
last_match_time TIMESTAMP);  

CREATE TABLE match_queue (     
match_id SERIAL PRIMARY KEY,     
player1_id VARCHAR,     
player2_id VARCHAR,     
status VARCHAR CHECK (status IN ('pending', 'matched', 'failed')),     created_at TIMESTAMP );
```

使用Redis 来进行存储
```json
{
    "order_id": "ORD12345",
    "user": {
        "user_id": "U001",
        "name": "Alice",
        "email": "alice@example.com"
    },
    "total_price": 150.50
}
```

匹配系统的核心需求是**低延迟、高吞吐量**，因此我们使用 **Redis 作为匹配队列** 来加速匹配。但由于游戏需要存储玩家的 Skill Rating 和历史匹配数据，我们仍然使用 **SQL 数据库存储长期数据**。这个设计能在**高性能**和**数据一致性**之间取得平衡。
#### 常用设计选择

**SQL 数据库（关系型数据库）**

| 数据库                  | 典型用途        | CAP 拆分         |
| -------------------- | ----------- | -------------- |
| MySQL                | Web 应用、事务处理 | CP（一致性 & 分区容忍） |
| PostgreSQL           | 高度扩展、复杂查询   | CP（一致性 & 分区容忍） |
| Oracle               | 企业级数据库      | CP（一致性 & 分区容忍） |
| Microsoft SQL Server | 企业应用、BI     | CP（一致性 & 分区容忍） 
**NoSQL 数据库（非关系型数据库）**

| 数据库       | 典型用途      | CAP 拆分         |     |
| --------- | --------- | -------------- | --- |
| MongoDB   | 文档存储、大数据  | AP（可用性 & 分区容忍） |     |
| Cassandra | 分布式系统、高吞吐 | AP（可用性 & 分区容忍） |     |
| Redis     | 高速缓存、消息队列 | AP（可用性 & 分区容忍） |     |
| CouchDB   | JSON 数据存储 | AP（可用性 & 分区容忍） |     |

## **Step 6: Scaling Strategies（扩展性 & 高可用）**

### **1. 水平扩展**

- **API Gateway** → 使用 **负载均衡（NGINX / AWS ALB）**
- **Matchmaking Service** → 运行多个实例（Kubernetes / AWS ECS）
- **Database** → 使用 **主从数据库** 读写分离

### **2. 高可用**

- **Redis / Kafka** 作为消息队列，确保匹配任务不会丢失
- **数据库 Replication**，避免单点故障

### **3. 低延迟优化**

- Redis **缓存热门玩家的 Skill Level**，减少 DB 查询压力
- **地理分布式匹配**，优先匹配相同地区玩家，降低网络延迟

---

## **Step 7: Trade-offs & Optimizations（权衡和优化）**

|**优化点**|**优点**|**缺点**|
|---|---|---|
|**使用 Redis 作为匹配队列**|匹配快，低延迟|需要额外维护|
|**ELO vs MMR**|MMR 更稳定|ELO 更易变|
|**跨区域 vs 本地匹配**|更容易找到对手|可能增加延迟|

---

## **Step 8: Summary（总结）**

1. 通过 **API Gateway** 处理请求，负载均衡
2. **Matchmaking Service** 计算匹配度，使用 **Redis 优先队列**
3. **Skill Rating DB** 维护玩家技能等级
4. **匹配成功的玩家** 进入 **Game Server** 进行对战
5. **优化策略** 包括 **缓存、分布式匹配、高可用架构**



