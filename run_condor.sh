#!/bin/bash
# Copyright (C) 2011 Tai Sakuma <sakuma@fnal.gov>

##____________________________________________________________________________||
jobDir=${1:-./tmp_condor}

##____________________________________________________________________________||
mkdir -p $jobDir

##____________________________________________________________________________||
submittedDir=$(pwd)

##____________________________________________________________________________||
let iProcess=0
while read -r line; do
    mkdir -p ${jobDir}/job.${iProcess}
    echo $line > ${jobDir}/job.${iProcess}/command.sh
    let iProcess=iProcess+1
done

##____________________________________________________________________________||
cat > ${jobDir}/condor_desc.cfg <<EOF
Universe   = vanilla
Executable = job.sh
Requirements = Memory >= 199 && OpSys == "LINUX" && (Arch != "DUMMY") && Disk > 1000000
Arguments  = ${jobDir}/job.\$(Process)
Log        = condor_job.log
Output     = condor_job.out
Error      = condor_job.error
initialdir = job.\$(Process)
should_transfer_files   = YES 
when_to_transfer_output = ON_EXIT
notification =  Never
# +LENGTH="SHORT"
Queue ${iProcess}
EOF

##____________________________________________________________________________||
cat > ${jobDir}/job.sh <<EOF
#!/bin/bash
source /uscmst1/prod/sw/cms/shrc prod
cd ${submittedDir}
eval \`scramv1 runtime -sh\`
source \$1/command.sh
EOF

##____________________________________________________________________________||
cd ${jobDir}
condor_submit condor_desc.cfg
