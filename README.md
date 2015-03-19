expbench
========

A simple MATLAB experiment bench.

Requirements:
=============
You'll need MATLAB (obviously), Python with psycopg2 package and a PostgreSQL
server. Once your PostgreSQL is ready and you have created your database, run
the SQL from expbench.sql to create the experiments table and its helpers.

The webpage genetor in `exp_daemon.py` requires the `make_webpage` toolbox
available at `https://github.com/iXce/make_webpage`.

The toolbox is thought for use with the APT cluster toolbox
(`https://github.com/iXce/APT`) but can decently work without it (you just have
to replace apt_taskid by whatever internal identifier your cluster scheduler
uses, or none).

`git-snapshot` (`https://github.com/nothingmuch/git-snapshot/`) is used to take
snapshots of the git repository at experiment start time.

To let MATLAB connect to PostgreSQL, you'll need to get the appropriate jdbc4
jar from the web (Google it!) and add it to the javaclasspath in MATLAB:

    javaclasspath(fullfile(pwd, 'postgresql-8.4-703.jdbc4.jar'));

Sample usage:
=============

The toolbox is made of a few functions and simple helper scripts, which you can
place in your standard experiment setup. Here's the grand scheme of things:
- You first define the parameters you want to use (say, from an outside
  script). You need to provide the toolbox the list of fields from you
  parameter combinations are generated, through the `expfields` variable, the
  number of runs, through `nruns`, and the number of runs per job, through
  `group_by`.
- `exp_start` asks the user for a name, summarizes the parameters in a single
  array, makes a git-snapshot and adds the experiment to the database. It also
  creates a time-based `expsuffix` you can reuse afterwards.
- You launch your task. If using APT, use the 'NoLoad' parameter to get back
  the APT task id ; `exp_end` will load the results.
- `exp_end` loads the results from APT, and sets the experiment as finished in
  the database and sets its apt_taskid.
- You automatically make some report on your experiment, maybe some raw data or
  maybe some report text, and maybe a results webpage. You use `exp_report(exp_id,
  reportdata, reporttext, page_url);` to store it in the database.
- Once in a while a cronjob runs `exp_daemon.py` (I run it every 10 minutes)
  and generates a webpage which summarizes all experiments, showing your text
  report, linking to the results webpage, showing the parameters, the APT
  taskid...

Here is a sample script, where the parameters were defined before as `vids` and
`lambdas`:

    group_by = 1;
    nruns = numel(vids) * numel(lambdas);

    expfields = {'vids', 'lambdas'};

    exp_start;

    APT_params
    global APT_PARAMS
    APT_PARAMS.exec_name = 'mytask';

    if recompile
        APT_compile({'myexperiment'});
    end

    apt_taskid = APT_run('myexperiment',...
        num2cell(vids),...
        num2cell(lambdas),...
        'CombineArgs', nruns > 1,...
        'ClusterID', 2,...
        'GroupBy', group_by,...
        'KeepTmp', 1,...
        'Memory', 2000, 'MemoryHard', 6000,...
        'NoLoad', 1);

    exp_end;

    % Obvious placeholders
    [reportdata, reportttext] = make_report(allresults);
    page_url = make_results_page(allresults, expsuffix);

    exp_report(exp_id, reportdata, reporttext, page_url);
