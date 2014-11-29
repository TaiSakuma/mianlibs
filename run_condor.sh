#!/bin/bash
# Copyright (C) 2013 Tai Sakuma <sakuma@fnal.gov>

##____________________________________________________________________________||
jobDir=${1:-./tmp_condor}

##____________________________________________________________________________||
mkdir -p $jobDir

##____________________________________________________________________________||
submittedDir=$(pwd)

##____________________________________________________________________________||
let iProcess=0
while read -r line; do
    echo $line > ${jobDir}/command_${iProcess}.sh
    let iProcess=iProcess+1
done

##____________________________________________________________________________||
cat > ${jobDir}/condor_desc.cfg <<EOF
Universe   = vanilla
Executable = job.sh
Requirements = OpSys == "LINUX" && (Arch != "DUMMY")
Request_memory = 199
Request_disk = 1000000
Arguments  = ${jobDir}/command_\$(Process).sh
Log        = condor_job_\$(Process).log
Output     = condor_job_\$(Process).out
Error      = condor_job_\$(Process).error
# initialdir = job.\$(Process)
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
echo \${_CONDOR_SCRATCH_DIR}
source \$1
EOF

##____________________________________________________________________________||
cd ${jobDir}
condor_submit condor_desc.cfg
