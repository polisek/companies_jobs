
local IS_SERVER = IsDuplicityVersion()
doingJob = false
doingJobName = nil


if not IS_SERVER then
    function StartJob(jobname)
        doingJob = true
        doingJobName = jobname
    end

    function StopJob(jobname)
        doingJob = false
        doingJobName = jobname
    end

    function PlayerDoJob()
        return doingJob
    end

    function PlayerDoThisJob(jobname)
        if doingJobName == jobname then
            return true
        end
        return false
    end
end