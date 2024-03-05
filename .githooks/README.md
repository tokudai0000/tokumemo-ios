# githooks
このディレクトリは本来であれば、.git/hooks/ に配置するディレクトリです。

.git は、リポジトリの設定を管理するディレクトリであり、バージョン管理対象外です。

そのため、.githooks/の内容を.git/hooks/へコピーすることで、リポジトリのGit操作に適用しています。

以下のコマンドは、mint setupの一部として実行されます。


```zsh
$ cp -r .githooks .git/hooks

$ chmod -R +x .git/hooks
```

# 参考
https://git-scm.com/docs/githooks

https://www.farend.co.jp/blog/2020/04/git-hook/
