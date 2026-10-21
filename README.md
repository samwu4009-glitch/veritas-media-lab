---
title: Veritas Media Lab
emoji: 🔎
colorFrom: blue
colorTo: yellow
sdk: docker
app_port: 7860
pinned: false
---

# Veritas Media Lab

这是一个基于 Flask 与前端页面的 AI 新闻核查和媒体认知实验平台。

## 🚀 如何在 Windows 上运行与修改代码

1. 在 VS Code 中打开 `Veritas_Media_Lab_Full` 项目文件夹。
2. 打开终端，确认当前目录是包含 `app.py` 的项目目录。
3. 首次运行时安装依赖：`py -m pip install -r requirements.txt`。
4. 在项目根目录创建 `.env` 文件（已被 `.gitignore` 忽略，不会被提交），写入一行 `DEEPSEEK_API_KEY=你的 API Key`，供 Truth Lab 分析和 Ask 对话使用。`.env` 中的值优先于系统环境变量。请勿把真实 Key 写入 HTML 或提交到代码中。
5. 双击项目中的 `启动 Veritas.bat`，脚本会启动 Flask 并自动打开正确的网站地址 `http://127.0.0.1:5000/`。也可以在终端中直接运行：
   ```powershell
   py app.py
   ```
   保持服务运行即可访问；按 `Ctrl + C` 可停止服务。请勿直接双击 `index.html`，Ask 和 Truth Lab 需要由 Flask 提供 API。

Truth Lab 与 Ask 共用后端 DeepSeek API 接入。Truth Lab 报告固定展示 SIFT（Stop、Investigate、Find、Trace）四步和 PIE（Point、Illustration、Evidence）三项。分析时先提取最多三条核心事实主张；中文材料会同时生成英文和原文语言的搜索词，并行查询 Google News RSS、Bing News RSS，并尝试 GDELT DOC 搜索。模型只根据实际检索到的标题、发布者和日期进行交叉比较。直接报道同一事件的标题可标为标题级支持，但不代表已核实全文；无关标题作为背景。分析不会自动抓取新闻全文，报告会附可点击的来源链接，便于打开原文复核。最终结果限定为“属实”“不实”“倾向于属实”“倾向于不属实”或“暂无法核实”：只有达到多域名、来源质量和无反向证据等门槛时才给出确定性结论；证据不足、冲突或在线搜索不可用时标注“暂无法核实”，不会为了输出结果硬凑真假或把无搜索结果说成反证。任何模型或检索流程都不能保证百分之百准确，标题/来源信息也不等于读过全文。公共 RSS 搜索无需在浏览器暴露密钥；多搜索源用于降低单点故障风险，但不能保证每个内地、香港网络或运营商都能访问上游服务。新闻页的 UN News 与今日头条源没有内容时，会依次尝试备用源，并在页面明确标注实际来源，不会把备用结果冒充为原始新闻源。PIE 证据段会区分用户提交的材料和搜索索引标题；SIFT 的 Find/Trace 使用实际查询结果和可追溯链接。报告末尾的“证据充分度”0–100 分由后端根据原文主张具体度、信源、原文一手证据、方法背景、数据及独立佐证六项加权计算（权重分别为 15、20、25、15、15、10）；它只衡量用户提交原文的完整度，不代表真假概率。历史记录默认显示摘要，展开后查看提交原文、完整分析和搜索来源。Ask 可回答不限主题的问题，并提供网站用途和 Truth Lab 使用方式的示例问题。DeepSeek API Key 只从 `DEEPSEEK_API_KEY` 环境变量读取，不要写入代码。

语音输入使用本机 Flask 服务中的 faster-whisper 多语言 `base` 模型离线转写；首次使用时会下载模型并缓存到用户目录，之后可离线识别。浏览器录音只发送到当前 Flask 服务，不会发送到语音识别云服务；本地运行时服务地址为 `127.0.0.1`，音频临时文件在处理后删除。若将网站部署到远程服务器，录音会发送到该服务器，因此不要在未告知用户的情况下启用。

Ask 不限制提问主题或应用内输入字符数；实际可处理长度仍受 DeepSeek 上下文容量限制。等待回答时显示 Thinking Orbs 粒子球；回答会清理 Markdown，并最多生成 600 个 token。对话区域固定高度、独立滚动且不会带动 Lenis 页面滚动。成功的 Ask 对话和 Truth Lab 分析会保存到数据库，并通过浏览器本地生成的匿名 UUID 关联；可在菜单的“我的历史”查看、继续 Ask 对话或删除该浏览器关联的全部历史。清除浏览器数据或换设备后无法找回；匿名 UUID 是访问历史的凭证，不等同于账号认证。内容会保留到用户手动删除，公开运营前应增加适当的数据保留与隐私告知策略。
相关对话最多携带最近 4 条上下文消息，每条最多 240 个字符。
Ask 与 Truth Lab 会根据输入文本自动选择回复语言：中文输入使用中文；英文输入以英文为主并附较小字号的中文辅助说明。Truth Lab 对中文繁体输入保留繁体输出。
如果系统代理无法连接，DeepSeek 请求会自动尝试直连；若直连也失败，Ask 会显示网络错误提示。
如果后端返回空响应或非 JSON 错误，Ask 与 Truth Lab 会显示 Flask 后端日志检查提示，而不会再显示 JSON 解析异常。
如果 DeepSeek 返回 HTTP 401，说明当前 API Key 被拒绝。请在 DeepSeek 控制台创建新 Key，将其保存为 Windows 用户环境变量 `DEEPSEEK_API_KEY`，然后重新双击 `启动 Veritas.bat`。启动脚本会读取最新的用户环境变量，并只在确认 5000 端口运行的是本项目时重启服务；不要把 Key 放入网页或聊天。

修改代码或图片后刷新浏览器即可查看更新。也可以使用 VS Code 的 **Go Live（Live Server）** 预览页面：它只负责提供前端静态文件，Truth Lab、Ask、历史和新闻接口仍由 Flask 提供。先运行项目根目录中的 `启动 Veritas.bat`，再访问 Flask 地址 `http://127.0.0.1:5000/`，或保持 Flask 运行并用 Go Live 预览；Go Live 默认端口（5500-5510）已配置为将 API 请求发送到本机 Flask。若后端未启动，新闻区会提示启动方式，而不会一直停在加载状态。

## 📁 目录结构说明
- `index.html`: 页面结构、样式与前端交互。
- `app.py`: Flask 网站服务与新闻数据接口。
- `启动 Veritas.bat`: 启动 Flask 服务并打开本地网站。
- `assets/`: 静态资源文件夹，方便你后续将网页部署到服务器。
  - `images/`: 原始图片保留在这里；网站优先使用 `images/optimized/` 中压缩后的本地 JPEG，并对非首屏图片延迟加载。替换图片后也应生成优化版本并更新 HTML 路径，避免依赖外部图片 CDN。
  - `css/`: `tailwind.css` 是预先编译好的样式文件（由 `tailwind.src.css` 和 `tailwind.config.js` 生成），`fonts.css` 为本地字体声明。
  - `js/vendor/`: 本地保存的 GSAP、ScrollTrigger、Lenis 脚本，不再依赖外部 CDN。
  - `fonts/`: 本地保存的网页字体（woff2）。
  - 修改 `index.html` 中的 Tailwind 类名后，需要重新编译样式（不要加 `--minify`，否则颜色会偏移 1）：
    `npx tailwindcss@3.4.17 -c ./tailwind.config.js -i ./assets/css/tailwind.src.css -o ./assets/css/tailwind.css`

## 🌐 Linux + PostgreSQL 公网部署

项目包含一套 Docker Compose 部署模板：PostgreSQL 保存数据，Flask 由 Gunicorn 提供服务，Nginx 接收公网流量。Nginx 为文本资源启用 gzip，并允许最多 16 MB 请求体以匹配语音转写接口的 15 MB 文件上限。浏览器只访问本站 `/api/...`；DeepSeek Key 由 Flask 从服务器环境变量 `DEEPSEEK_API_KEY` 读取，不会传给浏览器。当前新闻源也由 Flask 后端抓取。

### Cloudflare 临时隧道演示（免银行卡）

此方式在本机运行完整 Flask 服务，再通过 Cloudflare Quick Tunnel 暂时提供 HTTPS 访问；它不是常驻云端部署，也不需要访客注册或输入密码。此公开演示不限制 AI 使用量，所有访客会共用运行者的 DeepSeek API 额度；公开站点可能产生费用或遭到滥用。

启动 Flask 后，在另一终端运行 `cloudflared tunnel --url http://127.0.0.1:5002`。保持两项进程和 Mac 在线；Quick Tunnel URL 会变化且无在线保障。它不能保证中国内地或香港所有网络都能稳定访问，不应作为正式发布方案。SQLite 历史留在本机，Whisper 模型首次使用时下载到本机缓存。浏览器请求、提交的文本和录音会经 Cloudflare 转发至本机；文本还会发送给 DeepSeek，新闻检索词会发送给 Google News/Bing News。请勿用此演示站处理敏感材料。

内置图片使用本地压缩副本；Flask 对静态文件设置浏览器缓存，新闻源并行抓取并短时缓存。正式面向中国内地和香港发布仍需可持续运行的服务器、域名与网络实测；仅修改 Flask 或前端无法绕过临时隧道的覆盖范围、运营商路由及上游新闻/AI 服务可用性。

Hugging Face 当前免费个人帐户不能创建运行 Docker/Flask 的 Space；这类计算需要付费计划。若需要稳定的公共云服务，应使用支持 Flask、持久数据库和 Secrets 的托管方案。

## 🌍 GitHub 作品仓库 + Render 免费试运行

项目可将源码、页面和静态资源放在公开 GitHub 仓库，并通过根目录的 `render.yaml` 在 Render 创建 Flask Web 服务和 PostgreSQL。Render 负责运行后端；GitHub Pages 不能运行 Flask，因此不能单独保留分析、Ask、新闻抓取和历史功能。

1. 将项目源码与 `assets/` 上传到公开 GitHub 仓库，然后在 Render 选择 **New → Blueprint** 并连接该仓库，按 `render.yaml` 创建服务。
2. 在 Render 的 Web Service 环境变量设置中手动填写 `DEEPSEEK_API_KEY`，再部署。不要把本机 `.env`、API Key 或 `instance/veritas.db` 上传到公开仓库。
3. 等 Web Service 健康检查通过后，使用 Render 提供的 `onrender.com` 地址访问网站。Render 上首次使用语音识别时需要下载 Whisper 模型，首次转写会较慢。

**免费试运行限制：**免费 Web Service 可能休眠，唤醒时需要等待；其文件系统不持久，Whisper 模型可能在服务重启后重新下载。免费 PostgreSQL 有容量和有效期限制，不能作为永久历史存储；具体限制以 Render 控制台显示为准。当前本机 `instance/veritas.db` 中的历史不会自动迁移到 Render，远程数据库会从空数据开始。若要长期保留线上历史和模型缓存，需要升级到支持持久存储的套餐并另行迁移数据。

### 数据表

应用通过 Flask-SQLAlchemy 定义以下 PostgreSQL 表，并由 `flask --app app init-db` 创建缺失的表、为既有表增加匿名访客字段：

| 表 | 用途 |
| --- | --- |
| `users` | 预留用户资料、密码哈希、启用状态和创建时间；当前尚未开放注册或登录接口。 |
| `analyses` | 保存用户提交文本、Truth Lab 分析结果和匿名访客 ID，也可关联用户。 |
| `chat_messages` | 保存 Ask 对话消息，可按匿名访客和对话 ID 查询并关联用户；角色由数据库约束为 user/assistant。 |

目前仍没有注册/登录功能。匿名 ID 存在当前浏览器的 localStorage 中，任何能访问该浏览器数据的人都可能读取对应历史；它不提供真正的用户身份验证或跨设备同步。用户可从“我的历史”删除关联数据。新闻页有手动刷新和来源状态；上游不可用时会明确显示错误，不再把静态演示标题伪装成实时新闻。

### 本地运行

- Windows 仍可使用 `启动 Veritas.bat`。没有设置 `DATABASE_URL` 时，开发环境默认使用 `instance/veritas.db`（SQLite）；设置 `DATABASE_URL` 后可连接 PostgreSQL。
- PostgreSQL URL 支持 `postgresql://...` 或 `postgresql+psycopg://...`，应用会选用 psycopg 3 驱动。

### 服务器首次部署

准备一台安装 Docker Engine 和 Docker Compose 的 Linux 服务器，并将域名解析到服务器。不要在个人电脑上公开运行 Flask 开发服务器。

1. 将项目放到服务器，进入项目目录，创建服务器专用环境文件：
   ```sh
   cp .env.example .env
   ```
   编辑 `.env`，填写 DeepSeek Key，并把 PostgreSQL 用户密码替换为长的随机字母数字字符串。不要将真实 `.env` 提交到 Git；限制文件权限：
   ```sh
   chmod 600 .env
   ```
2. 启动 PostgreSQL、Gunicorn 和 Nginx：
   ```sh
   docker compose up --build -d
   docker compose ps
   ```
   `postgres_data` 是持久卷，容器重建不会删除数据库。首次启动会等待 PostgreSQL 健康检查、创建缺失表，再启动 Gunicorn（1 个 worker、4 个线程）。
3. 在服务器防火墙开放 80/443。首次启动先通过 HTTP 完成 ACME 验证。安装 Certbot 后，在项目目录执行（将域名和邮箱换成自己的）：
   ```sh
   mkdir -p deploy/certbot/www
   sudo certbot certonly --webroot -w "$PWD/deploy/certbot/www" -d your-domain.example --email you@example.com --agree-tos --no-eff-email
   ```
4. 在 `deploy/nginx-https.conf` 中把两处 `your-domain.example` 换成真实域名；然后将 `docker-compose.yml` 中 Nginx 的配置挂载文件由 `deploy/nginx.conf` 改为 `deploy/nginx-https.conf`，并重建 Nginx：
   ```sh
   docker compose up -d --force-recreate nginx
   ```
   确认 HTTPS 和证书续期正常后，建议将 80 端口只用于跳转/ACME 验证。不要长期以明文 HTTP 对公网提供服务。
5. `docker compose logs -f web` 查看 Flask/Gunicorn 日志；备份 PostgreSQL：
   ```sh
   docker compose exec -T db sh -c 'pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB"' > veritas-backup.sql
   ```
   同时为 Certbot 续期设置 deploy hook，在证书更新成功后执行 `docker compose exec -T nginx nginx -s reload`。

### 密钥与公网滥用防护

- `.env` 只放在服务器，权限设为 `600`；轮换 API Key 时更新服务器变量并重启 `web` 容器：`docker compose up -d --force-recreate web`。
- 不要将密钥写进 HTML、JavaScript、Git、截图或客户端请求。拥有服务器/Docker 管理权限的人仍能访问容器环境变量；应限制服务器管理员和 Docker socket 的权限。
- Nginx 模板对 `/api/ask`、`/api/analyze` 做按 IP 限流（每分钟 10 次，另有短时突发额度），避免公开 API 被无限调用；共享网络/代理下的用户会共用出口 IP 限额。
- 限流不是用户认证或计费系统。若要对公网长期开放 AI 功能，建议再实现账号/验证码、按用户额度和审计；只允许同源访问，不要为图方便开放任意 CORS。
