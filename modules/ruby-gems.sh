rubyGems() {
    # function that removes gems and gemspecs from the current ruby.
    cleanCurrentRuby() {
        # gemsets for current ruby
        command -v gem >/dev/null 2>&1 && {
            local GEMPATHS=$(gem env gempath | tr ':' '\n')
            IFS=$'\n' # make newlines the only separator
            for GEMPATH in "${GEMPATHS}"; do
                local GEMDIR="${GEMPATH}/gems"
                local SPECDIR="${GEMPATH}/specifications"
                if [ -d "${GEMDIR}" ]; then
                    local GEMDIRSIZE=$(du -hs "${GEMDIR}" | cut -f1)
                    echo "      - ${GEMDIR} (${GEMDIRSIZE})"
                fi
                if [ -d "${SPECDIR}" ]; then
                    local SPECDIRSIZE=$(du -hs "${SPECDIR}" | cut -f1)
                    echo "      - ${SPECDIR} (${SPECDIRSIZE})"
                fi
            done
            unset IFS
            # remove gems
            gem cleanup -d
        }
    }

    cleanCurrentRuby

    # rvm - iterate for each ruby version installed, removing gems
    command -v rvm >/dev/null 2>&1 && {
        echo "=== cleaning up rvm-managed ruby gems ===="
        local RVM_RUBIES=$(rvm list strings)
        echo "  - found rubies: '${RVM_RUBIES}'"
        IFS=$'\n' # make newlines the only separator
        local RVM_RUBIES=$(echo "${RVM_RUBIES}")
        echo "  - found rubies: '${RVM_RUBIES}'"
        for RVM_RUBY in ${RVM_RUBIES}; do
            echo "rvm use ${RVM_RUBY}"
            rvm use ${RVM_RUBY}
            cleanCurrentRuby
        done

        unset IFS
        rvm use
    }

    addHint "- You might need to reinstall your ruby gems"
    addHint "  - e.g. gem install cocoapods"
}
