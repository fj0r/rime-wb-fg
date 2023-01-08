linux:
    sudo cp -f wubi86_fg* pinyin_simp* /usr/share/rime-data/
    sudo yq -i e '.schema_list[0].schema="wubi86_fg_pinyin"' /usr/share/rime-data/default.yaml
    sudo rime_deployer --build ~/.config/ibus/rime /usr/share/rime-data ~/.config/ibus/rime/build
