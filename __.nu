const s = {
    wubi86: 'wubi86_fg.dict.yaml'
}

export def 'search' [code, file] {
    mut lns = []
    mut i = ($code | str length)
    loop {
        if $i == 0 { break }
        let t = $code | str substring 0..<$i
        let r = (rg -n $"\\s($t)" $file | lines)
        if not ($r | is-empty) {
            $lns = $r
            break
        }
        $i -= 1
    }
    let lst = $lns
    | each {
        let s = $in | split row ':'
        {value: ($s.0 | into int), description: $s.1}
    }
    [
        ...$lst
        {value: (($lst | last).value + 1), description: $code}
    ]
}

export def 'get_code' [word, file] {
    let chars = $word | split row '' | filter { $in != '' }
    let code = match ($chars | length) {
        1 => [
                [0 0..<4]
        ]
        2 => [
                [0 0..<2]
                [1 0..<2]
        ]
        3 => [
                [0 0..<1]
                [1 0..<1]
                [2 0..<2]
        ]
        4 => [
                [0 0..<1]
                [1 0..<1]
                [2 0..<1]
                [3 0..<1]
       ]
        _ => [
                [0 0..<1]
                [1 0..<1]
                [2 0..<1]
                [(-1) 0..<1]
       ]
    }
    $code
    | each {|x|
        let c = if $x.0 == (-1) { $chars | last } else { $chars | get $x.0 }
        rg $'^($c)\s' $file
        | lines
        | reduce -f '' {|i,a|
            if ($i | str length) > ($a | str length) {
                $i
            } else {
                $a
            }
        }
        | split row (char tab)
        | get 1
        | str substring $x.1
    }
    | str join ''
}

export def 'setup linux' [] {
    sudo cp -f wubi86_fg* pinyin_simp* /usr/share/rime-data/
    sudo cp -f default.yaml /usr/share/rime-data/default.yaml
    sudo cp -f default.custom.yaml /usr/share/rime-data/default.custom.yaml
    # sudo yq -i e '.schema_list[0].schema="wubi86_fg_pinyin"' /usr/share/rime-data/default.yaml
    sudo rime_deployer --build ~/.config/ibus/rime /usr/share/rime-data ~/.config/ibus/rime/build
}

def cmpl-dict [ctx] {
    let x = $ctx | argx parse
    let code = get_code $x.pos.word $s.wubi86
    search $code $s.wubi86
}

export def 'dict wubi86' [word offset:string@cmpl-dict] {
    let code = get_code $word $s.wubi86
    pp sed -i $'($offset) i ($word)(char tab)($code)' $s.wubi86
}

export def 'dict get_code' [word] { get_code $word $s.wubi86 }

export def 'dict search' [word] { search $word $s.wubi86 }
