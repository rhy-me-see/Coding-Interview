## **1) 结构性标签（布局）**

这些标签用于组织页面的整体结构，在**HTML5** 中尤其重要。
```html
<header>网站标题或导航栏</header>
<nav>导航栏</nav>
<main>网页主要内容</main>
<section>内容分块</section>
<article>独立的文章内容</article>
<aside>侧边栏</aside>
<footer>页脚信息</footer>
```

🔹 **示例：**
```html
<header>
    <h1>我的网站</h1>
    <nav>
        <a href="#about">关于</a> | <a href="#contact">联系</a>
    </nav>
</header>
<main>
    <section id="about">
        <h2>关于我们</h2>
        <p>我们是一家科技公司。</p>
    </section>
</main>
<footer>© 2025 我的公司</footer>
```

📌 **面试考点**：

- 语义化 HTML（semantic HTML）
- SEO 友好（搜索引擎更容易理解）
- 可访问性（对屏幕阅读器友好）

---

## **2) 文本标签**

这些标签用于组织页面上的文本内容。
```html
<h1>标题 1</h1>
<h2>标题 2</h2>
<p>段落</p>
<strong>加粗文本</strong>
<em>斜体文本</em>
<mark>高亮文本</mark>
<u>下划线</u>
<del>删除线</del>
<small>小号文本</small>
<blockquote>引用内容</blockquote>
<pre>保留格式的文本</pre>
<code>代码块</code>
```

🔹 **示例：**
```html
<h1>面试考点</h1>
<p>在 HTML 面试中，可能会考<strong>语义化</strong>标签的使用。</p>
<blockquote>“让 HTML 结构更有意义。”</blockquote>
<pre>
function hello() {
    console.log("Hello, world!");
}
</pre>
```

📌 **面试考点**：

- `strong` vs `b`（`strong` 有语义，`b` 只是样式）
- `em` vs `i`（`em` 语义化，`i` 仅表示斜体）
- `pre` vs `code`（`pre` 保留格式，`code` 适用于单行代码）

---

## **3) 列表标签**

HTML 支持**有序列表**、**无序列表** 和 **描述列表**。
```html
<ul>
    <li>苹果</li>
    <li>香蕉</li>
    <li>橙子</li>
</ul>

<ol>
    <li>第一步</li>
    <li>第二步</li>
    <li>第三步</li>
</ol>

<dl>
    <dt>HTML</dt>
    <dd>超文本标记语言</dd>
</dl>
```


📌 **面试考点**：

- `ul` vs `ol`（无序列表 vs 有序列表）
- `dl` 适用于**词汇表或术语定义**

---

## **4) 表单标签**

表单是面试中最重要的部分之一，包括输入框、按钮等：
```html
<form action="/submit" method="POST">
    <label for="username">用户名:</label>
    <input type="text" id="username" name="username" placeholder="输入用户名" required>

    <label for="email">邮箱:</label>
    <input type="email" id="email" name="email" required>

    <label for="password">密码:</label>
    <input type="password" id="password" name="password" required>

    <label>性别:</label>
    <input type="radio" name="gender" value="male"> 男
    <input type="radio" name="gender" value="female"> 女

    <label for="hobby">爱好:</label>
    <select id="hobby" name="hobby">
        <option value="reading">阅读</option>
        <option value="sports">运动</option>
    </select>

    <label>喜欢的颜色:</label>
    <input type="color" name="favColor">

    <label>生日:</label>
    <input type="date" name="birthdate">

    <label>上传文件:</label>
    <input type="file" name="fileUpload">

    <input type="submit" value="提交">
</form>
```

📌 **面试考点**：

- `<input>` 的 `type` 属性（`text`、`email`、`password`、`radio`、`checkbox`、`date`、`file` 等）
- `required`、`placeholder`、`name` 这些属性的作用
- `label` 的 `for` 绑定 `input`，提高可访问性

## **5) 表格标签**

表格主要用于展示结构化数据：
```html
<table border="1">
    <thead>
        <tr>
            <th>姓名</th>
            <th>年龄</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>张三</td>
            <td>25</td>
        </tr>
        <tr>
            <td>李四</td>
            <td>30</td>
        </tr>
    </tbody>
</table>
```

📌 **面试考点**：

- `thead`、`tbody`、`tfoot` 的作用
- `colspan` 和 `rowspan` 用于**合并单元格**

## 6）多媒体标签 / 7）交互标签

https://chatgpt.com/c/67cde45a-cf48-8005-94df-bfd308edd163

