
### General Information

Ads Product: https://discord.com/ads/quests
## Retrospective Exercise (技术回顾 & 复盘)

STAR Principle (Situation / Target / Action / Result)
Company Culture (https://discord.com/blog/the-seven-principles-of-working-at-discord) 
```
Cultivate Belonging --> 善意理解，努力理解其它人的观点
Deliver for Customers --> 关注需求，而不是竞争
Surprise & Delight --> 关心细节
Debate, Decide, Commit --> 收集信息，推动决策落地, 协调不同意见
Progress Over Perfection --> 长远考虑，分解想法
Embrace the Brutal Facts --> 冒险做重要的事情
Strive for Excellence --> 抓住机会做值得骄傲的工作，发挥周围人潜能
```


#### **Question: Tell me about a time you improved from feedback.**

**Situation:** Early in my career, I used to focus on providing very detailed responses when communicating with teammates. For example,

1. When someone asked a question in a Slack channel, I would take 5-10 minutes crafting a comprehensive response, including paragraphs, bullet points, and code pointers. I believed over-communication was better than under-communication.
2. When writing design docs, I aimed to cover everything thoroughly, leading to lengthy and dense documents.

**Task:** However, I received feedback from both peers and managers that while my responses were informative, they were sometimes overwhelming or not tailored to the audience’s immediate needs. I realized that effective communication isn’t just about completeness—it’s about **understanding what the audience actually needs**.

**Action:**

- I started **asking clarifying questions** before responding to ensure I understood the core issue, rather than assuming more details were always better.
- When writing design docs, I **prioritized structure over exhaustive details**, ensuring clarity while making it easy for different stakeholders (engineers, PMs, designers) to find relevant information.
- I also sought feedback actively after making changes to ensure my adjustments were actually helping.

**Result:** These changes significantly improved team efficiency. I received positive feedback from both engineers and cross-functional partners that my communication was now more effective, leading to faster decision-making and better alignment across teams.

#### Most challenging Project
|                                                                       |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| --------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Situation                                                             | In Q4 2024, our monetization team and executives planned to introduce a new ad format for VIP customers like Apple and Disney. This ad would take up a regular cell in the Friends Feed, occupying extra vertical space.<br><br>However, our Friends Feed already contained two other content types (non-friends chat cells and stories). The biggest concern was that if all three types appeared at the same time, the core chat function could be pushed down, negatively impacting chat engagement and story views, which are critical metrics.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| Task                                                                  | Our product goal was to ensure that ads and other non-chat content would not appear together to prevent UI clutter while maintaining maximum ad visibility. Additionally, this new format had a strict launch timeline, requiring us to build suppression logic to avoid conflicts while ensuring a smooth rollout.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| Action<br><br>[Break Down Urgency into Short Term and Long Term Plan] | The main challenge was that each content source was rendered asynchronously and independently, making it difficult to coordinate suppression dynamically. To solve this, I led the design and execution strategy, breaking down the problem into:<br><br>1. Short-Term Plan (Q4 Execution):<br><br>- Aligned stakeholders (Monetization, Product, and Engineering) on key objectives:<br>- Maximize ad visibility while keeping visual jitter under control.<br>- Defined acceptable UI tolerance for conflicts.<br>- Established win metrics to measure success.<br><br>- Designed a suppression mechanism that allowed flexible prioritization of content when rendering.<br>    <br><br>3. Long-Term Plan (Q1 2025 Roadmap):<br>- Proposed a centralized coordination system to dynamically manage asynchronous content rendering.<br>- Introduced two suppression strategies to determine when and how different content types should be displayed together.<br>- Ensured momentum and resourcing to continue refining the solution. |
| Result                                                                | We successfully delivered the new ad format on time with the suppression logic in place, preventing major UI disruptions. Additionally, we secured buy-in for the long-term coordination system, ensuring a scalable approach for managing asynchronous content in the future.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
#### **Question: Tell me about a time you made a decision for the team.**

**Situation:** About 1.5 years ago, our in-app feature promotion platform had built most of the necessary components and was successfully supporting engineers from customer teams in configuring, experimenting, and launching campaigns. However, we soon realized that non-technical teams—such as Growth Managers and Sales—also needed to onboard seasonal campaigns (e.g., holiday lenses) but lacked engineering support.

**Task:** The challenge was to **enable non-technical users to create and manage campaigns independently**, removing the bottleneck of requiring an engineer for each setup.

**Action (Debate & Decide):**

- I led the design of a **self-serve tool**, providing a web interface where users could configure key campaign settings (e.g., strings, icons, cooldown settings, A/B setup).
    
- To make key technical decisions, I:
    
    1. **Explored different internal service deployment options** by reading documentation and reaching out to teams with similar services.
    2. **Evaluated technical stacks** based on maintainability, scalability, and alignment with our existing ecosystem.
    3. **Facilitated discussions** with relevant stakeholders, including frontend, backend, and infra teams, to validate feasibility.
- **Final Decision:**
    
    - **Service deployment**: Chose to launch via the most widely used **Switchboard service**, ensuring alignment with internal infrastructure and ease of long-term maintenance.
    - **Tech stack**:
        - **Frontend**: TypeScript + React → Modern development patterns, strong ecosystem, and internal expertise.
        - **Backend**: Kotlin → Allowed us to leverage JAR packages easily, provided modern language features, and aligned with Android developers for better collaboration.

**Result (Commit & Execute):**

- Successfully launched the self-serve tool, enabling **5-10 internal teams per quarter** to onboard campaigns without engineering help.
- Reduced initial campaign setup time from **4 hours to 20 minutes**, significantly increasing operational efficiency.


#### Tell me about a time when you had to prioritize progress over perfection.

**Situation:**  
In one of our A/B tests, we observed a slight **DAU regression** caused by poorly converting campaigns. Specifically, some users were repeatedly shown a campaign prompt (e.g., enabling a setting they never intended to use), leading to **wasted impressions and frustration**.

**Task:**  
We needed to test ways to **reduce unnecessary campaign impressions** by introducing **suppression signals**, including:

1. **Unread messages in the friend feed chat** → If a user has unread messages, deprioritize non-essential campaigns.
2. **Recent active conversations** → If a user had more than 10 active conversations in the past 3 days, deprioritize non-essential campaigns.

The most robust way to implement this would have been to **fully integrate new suppression signals** into our campaign framework by onboarding:

- `unread_message_count`
- `active_conversation_count`  
    However, this approach required **2-3 weeks** due to platform changes and backend updates.

**Action (Progress Over Perfection Approach):**  
Instead of fully integrating the signals upfront, I suggested a **faster, iterative approach** by using a **config gate**:

- We **fetched the unread message count and active conversation count dynamically**, binding them to a temporary config key.
- This only required **1-2 PRs per platform** and a **single branch promotion** to deploy to production.
- This allowed us to **run an experiment first** to determine if these signals actually improved user experience **before committing to full implementation**.

**Result:**

- **The unread message signal showed a positive impact** on suppression logic, confirming its value.
- **The active conversation count signal had negligible impact**, so we **avoided unnecessary engineering work**.
- By validating our hypothesis **before full integration**, we **saved 2 weeks of engineering effort** while achieving the intended campaign improvement **2 weeks earlier**.


#### Tell me about a time when you went above and beyond to deliver high-quality work.

**Situation:**  
There was an engineer on my team who was excellent at making **technical decisions**, but I noticed that sometimes **PMs didn’t fully trust his direction**. This led to friction, and because of that, he would occasionally **get frustrated and withdraw from discussions**, making collaboration even harder.

**Task:**  
I wanted to **help him improve his influence** so that his technical expertise could be better recognized and his ideas could be adopted more smoothly.

**Action:**  
I suggested a few **practical strategies** to improve his communication and influence:

1. **Use a data-driven approach** → Instead of relying purely on intuition or technical reasoning, I encouraged him to back up his arguments with **metrics, experiment results, and past learnings** to make his recommendations more persuasive.
2. **Increase visibility of his thinking process** → I advised him to post more **concise yet insightful updates** in team channels. These updates highlighted:
    - How he analyzed the problem
    - Why a certain opportunity was worth pursuing
    - His rationale for a particular technical approach

**Result:**

- Over time, his **influence grew**, as stakeholders started to see the reasoning behind his decisions.
- He **built stronger trust with the PMs**, leading to smoother collaboration.
- He started to feel a **better team dynamic ("chemistry")**, making it easier for him to push his ideas forward and execute his work effectively.

#### Tell me about a time when you had to pivot based on new information.