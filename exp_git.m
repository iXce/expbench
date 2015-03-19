system('git-snapshot');
[~, gitcommit] = system('git rev-parse --short refs/snapshots/refs/heads/master');
