SDK_POSTPROCESS_COMMAND_prepend_sdkmingw32 = "cull_win_files;"

cull_win_files () {
    # Cull duplicates caused by case insensitive filesytems, e.g. NTFS
    cd "${SDK_OUTPUT}"
    find . >cull.filelist
    cat cull.filelist | tr '[:upper:]' '[:lower:]' | sort | uniq -d | \
        while read case_dupe; do
            # Remove all but one of each set of duplicates
            bbnote "Keeping first case duplicate '$(grep -xi "$case_dupe" cull.filelist | sed -n '1p')'"
            grep -xi "$case_dupe" cull.filelist | sed '1d' | while read actual; do
                bbwarn "Removing case duplicate '${actual#.}' for windows SDKMACHINE"
                rm -r "$actual"
            done
        done

    # Cull paths with invalid characters
    grep -E "\\\\|\?|:|\*|\"|<|>|\|" cull.filelist | while read invalid; do
        bbwarn "Removing file with invalid characters for windows SDKMACHINE: ${invalid#.}"
        rm "$invalid"
    done
}
