# my-dsh-plugins

本目录存放这个 fork 里的自定义插件（不进入 `pnpm-workspace`，通过 `--patch` 覆盖层挂载）。

## 运行方式

```sh
# 1) 安装依赖（首次）
pnpm install

# 2) 构建（首次或改动了 packages/ 下的源码后）
pnpm run build

# 3) 带覆盖层启动 Web UI
pnpm dsh web --patch ./my-dsh-plugins/hello/cordis.yml
```

启动后访问 `http://127.0.0.1:3080`，终端应打印 `[hello-plugin] plugin loaded!`。

## 新建一个插件

1. 复制 `hello/` 为新目录，例如 `my-dsh-plugins/my-feature/`。
2. 修改 `src/*.ts`，把 `name` 改成唯一名称。
3. 在 `my-dsh-plugins/my-feature/cordis.yml` 里把 `name:` 换成新文件的**绝对路径**
   （可用 `echo "$(pwd)/my-dsh-plugins/my-feature/src/my-feature.ts"` 生成）。
4. 启动时叠加多个覆盖层即可：`--patch a.yml --patch b.yml`。

## 插件形态

- 函数形式：`export function apply(ctx: Context)`（最简单，足够大多数场景）。
- 对象/类形式：需要对外提供 service 时使用，见 `docs/user/develop/basic/index.zh.md`。
- 依赖其他服务：`export const inject = ['tools']`，框架会等依赖就绪后再 apply。
- 资源清理：`ctx.effect(() => () => cleanup())`；通过 `ctx` 注册的东西会自动清理。

## 参考文档

- 第一个插件：`docs/user/develop/basic/index.zh.md`
- 开发工具：`docs/user/develop/basic/tool.zh.md`
- 插件配置：`docs/user/develop/basic/config.zh.md`
- 发布插件：`docs/user/develop/basic/publish.zh.md`
- 服务与依赖：`docs/user/develop/framework/service.zh.md`
- 浏览器端（client）插件：`docs/subsystems/client-modules.zh.md`
