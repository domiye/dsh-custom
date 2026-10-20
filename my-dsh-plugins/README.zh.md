# my-dsh-plugins

这个目录存放本 fork 的自定义插件。插件通过 `--patch` 覆盖层挂载，**不进入 `pnpm-workspace`**，也不改动上游 `packages/`。

## 独立开发环境（重要）

为避免和本机已安装的 dsh（`~/.dsh`，版本 0.1.0-rc.6）互相污染，源码开发使用**仓库内独立的 `DSH_HOME`**：

```
deepseek-harness/.dsh-dev/     ← 独立 DSH_HOME（profile、session、storage 都在这里）
deepseek-harness/.dsh-dev/profiles/web/
```

`my-dsh-plugins/dev.sh` 已封装好：

```sh
./my-dsh-plugins/dev.sh              # 启动（会自动带上 hello 覆盖层）
./my-dsh-plugins/dev.sh --port 3085  # 换端口
```

## 首次准备

```sh
pnpm install       # 依赖（已装好）
pnpm run build     # 构建 host + client 产物（已构建过一次）
```

## 目录结构

```
my-dsh-plugins/
  dev.sh                 # 独立 DSH_HOME 的启动脚本
  hello/                 # 最小 host 插件示例（函数形式）
    cordis.yml           # 覆盖层：把插件插入 loader 树
    src/hello.ts
```

## 新增插件

1. 复制 `hello/` 为新目录，如 `my-dsh-plugins/my-feature/`。
2. 改 `src/*.ts` 里的 `name`（必须唯一）。
3. 覆盖层里的 `name:` 必须是插件的**绝对路径**：
   `echo "$(pwd)/my-dsh-plugins/my-feature/src/my-feature.ts"`。
4. 多个覆盖层可叠加：`--patch a.yml --patch b.yml`（`dev.sh` 已默认带一个）。

## 插件形态

- 函数形式：`export function apply(ctx: Context)` —— 最简单。
- 对象 / 类形式：需要对外提供 service 时使用，见 `docs/user/develop/basic/index.zh.md`。
- 声明依赖：`export const inject = ['tools']`，框架等依赖就绪后再 `apply`。
- 资源清理：`ctx.effect(() => () => cleanup())`；经 `ctx` 注册的东西自动清理。
- **客户端（UI）插件**：包内声明 `dsh.client`（`platform: 'web'`）+ `exports["./client"]`，
  在 `apply(ctx)` 里 `inject = ['slots']`，用 `ctx.slots.register({ name: '<slot>' }, Component)`
  往父级声明过的 slot 里塞 React 组件。最小模板见
  `packages/client/ui-brand-official/`（全部客户端代码只有 42 行）。

## 参考文档

- 第一个插件：`docs/user/develop/basic/index.zh.md`
- 开发工具：`docs/user/develop/basic/tool.zh.md`
- 插件配置：`docs/user/develop/basic/config.zh.md`
- 发布插件：`docs/user/develop/basic/publish.zh.md`
- 服务与依赖：`docs/user/develop/framework/service.zh.md`
- 浏览器端插件机制：`docs/subsystems/client-modules.zh.md`
- Slot 注册表：`docs/subsystems/slots.zh.md`

## 已知约束

- 本机已安装的第三方插件（dsh-better-sidebar 0.13.0、dsh-context 0.33.1 等）声明依赖
  `@deepseek-ai/dsh-* ^0.1.0-rc.6`，在 **0.2.1-rc.2 源码版**里会被跳过——独立 `DSH_HOME`
  里不加载它们，正好互不影响。
