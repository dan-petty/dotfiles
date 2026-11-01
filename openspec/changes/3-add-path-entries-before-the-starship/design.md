# Design

## Decisions

- **Move the PATH block above the starship check rather than making the starship check search a custom path list.**: Setting up the environment before checking for tools is the conventional ordering. It is simpler to maintain and matches the remedy proposed in the issue body.
- **Use typeset -U PATH path (both names) rather than typeset -U path alone.**: The issue body confirms that typeset -U path alone does not remove duplicates introduced by a scalar export PATH=... assignment. Both PATH and path must be marked unique.

## Rejected alternatives

- **Make the starship check search a hardcoded list of directories instead of relying on PATH.**: This duplicates the directory list in two places. It is harder to maintain and deviates from the conventional pattern of setting PATH first.
- **Use typeset -U path without PATH.**: The issue body states this was checked and does not remove duplicates from a scalar export PATH=... assignment. Both names are required.
