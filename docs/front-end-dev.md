# For develop Laravel front-end

## For start work in new project

```shell
cd LARAVEL_PROJECT_DIR
valerka init
valerka watch
```

### Open in browser [http://localhost](http://localhost)

---

## Continue work with project

|                  |                               |
| ---------------- | ----------------------------- |
|`valerka watch`   | same as `npm run watch`       |
|`valerka npm`     | same as `npm run production`  |
|`valerka npm-dev` | same as `npm run development` |

---

## How to install package

```shell
valerka shell-node
npm install PACKAGE-NAME
```

## How to remove package

```shell
valerka shell-node
npm uninstall PACKAGE-NAME
```

## How to use yarn

```shell
valerka shell-node
yarn install
```

## How to update `valerka`

```shell
valerka valerka-update
```

### What version now used:

```shell
valerka shell-node
node -v
npm -v
yarn -v
```

| package | version |
| ------- | ------- |
| nodejs  | 10.15.1 |
| npm     | 6.8.0   |
| yarn    | 1.13.0  |

## Troubleshooting

### Error

```error
Found bindings for the following environments:
  - Linux/musl 64-bit with Node.js 11.x
```

### Fix

```shell
valerka node-shell
npm rebuild node-sass
```