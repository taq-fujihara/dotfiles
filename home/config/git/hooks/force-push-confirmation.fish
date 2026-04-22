#!/usr/bin/env fish

# Pre-push hook that detects non-fast-forward updates and requires re-typing
# the destination branch name before the push is allowed to continue.


function short_ref_name --argument-names ref
    if string match --quiet 'refs/heads/*' -- $ref
        string replace --regex '^refs/heads/' '' -- $ref
    else
        echo $ref
    end
end


set -l remote_name $argv[1]
if test -z "$remote_name"
    set remote_name $argv[2]
end
set -l zero_oid (string repeat --count 40 0)
set -l forced_remote_refs


# example of standard input: refs/heads/master 67890 refs/heads/foreign 12345
while read --line line
    set -l fields (string split ' ' -- $line)

    if test (count $fields) -ne 4
        continue
    end

    set -l local_ref $fields[1]
    set -l local_oid $fields[2]
    set -l remote_ref $fields[3]
    set -l remote_oid $fields[4]

    if test "$local_ref" = "(delete)"
        continue
    end

    if test "$remote_oid" = "$zero_oid"
        continue
    end

    command git merge-base --is-ancestor $remote_oid $local_oid >/dev/null 2>/dev/null
    if test $status -eq 0
        # The remote ref is already an ancestor of the local ref, so this is
        # effectively a fast-forward push, not a practical force push.
        continue
    end

    if not contains -- $remote_ref $forced_remote_refs
        set -a forced_remote_refs $remote_ref
    end
end

if test (count $forced_remote_refs) -eq 0
    # All updates were deletes, new refs, or fast-forwards, so there is no
    # practical force push to confirm.
    exit 0
end

for remote_ref in $forced_remote_refs
    set -l expected_ref (short_ref_name $remote_ref)

    echo '** "force push" detected **' >&2
    echo "Remote: $remote_name" >&2
    echo "Ref: $expected_ref" >&2

    if not test -r /dev/tty
        echo "Cannot confirm the force push without a terminal." >&2
        exit 1
    end

    read --local --prompt-str="Type remote branch name to force push to: " answer </dev/tty

    if test "$answer" != "$expected_ref"
        echo "You typed the wrong branch name. Please try again." >&2
        exit 1
    end

    echo "You typed the correct branch name. Proceeding to force push." >&2
end
