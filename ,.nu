$env.comma_scope = {|_|{
    created: '2024-01-02{2}15:07:18'
    computed: {$_.computed:{|a, s| $'($s.created)($a)' }}
    wubi86: 'wubi86_fg.dict.yaml'
    search: {|code, file|
        mut lns = []
        mut i = ($code | str length)
        loop {
            if $i == 0 { break }
            let t = $code | str substring 0..$i
            let r = (rg -n $"\\s($t)" $file | lines)
            if not ($r | is-empty) {
                $lns = $r
                break
            }
            $i -= 1
        }
        $lns
        | each {
            let s = $in | split row ':'
            {value: $s.0, description: $s.1}
        }
    }
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
    add: {
        wubi86: {
            $_.a: {|a,s|
                let code = $a.0
                let word = $a.1
                let offset = $a.2
                pp sed -i $'($offset) i ($word)(char tab)($code)' $s.wubi86
            }
            $_.c: {|a,s|
                let code = $a.0
                do $s.search $code $s.wubi86
            }
        }
    }
}}
