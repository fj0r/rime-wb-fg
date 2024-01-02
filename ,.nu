$env.comma_scope = {|_|{
    created: '2024-01-02{2}15:07:18'
    computed: {$_.computed:{|a, s| $'($s.created)($a)' }}
}}

$env.comma = {|_|{
    created: {|a, s| $s.computed }
    inspect: {|a, s| {index: $_, scope: $s, args: $a} | table -e }
    vscode-tasks: {
        $_.a: {
            mkdir .vscode
            ', --vscode -j' | do $_.batch ',.nu' | save -f .vscode/tasks.json
        }
        $_.d: "generate .vscode/tasks.json"
        $_.w: { glob: ',.nu' }
    }
    setup: {
        linux: {
            sudo cp -f wubi86_fg* pinyin_simp* /usr/share/rime-data/
            sudo cp -f default.yaml /usr/share/rime-data/default.yaml
            # sudo yq -i e '.schema_list[0].schema="wubi86_fg_pinyin"' /usr/share/rime-data/default.yaml
            sudo rime_deployer --build ~/.config/ibus/rime /usr/share/rime-data ~/.config/ibus/rime/build
        }
    }
}}
