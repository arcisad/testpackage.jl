using LocalRegistry
using Pkg
using TOML

function main()
    project_dict = TOML.parsefile("Project.toml")

    # get the package name
    package_name = project_dict["name"]

    # check if Project toml file is valid
    if !haskey(project_dict, "version")
        throw("No version found in Project.toml file")
    else
        # read the diff between current and last commit
        diff = readlines(`git diff HEAD^ HEAD Project.toml`)
        # check if the version has changed
        if all(.!occursin.("version", diff))
            @info "No change in the package version"
            return ""
        end
        # get the old version
        old_version = strip(string(split(diff[findall(line -> occursin.("-version", line), diff)][1], " = ")[2]), '\"')
        new_version = strip(string(split(diff[findall(line -> occursin.("+version", line), diff)][1], " = ")[2]), '\"')

        is_version_valid = VersionNumber(new_version) > VersionNumber(old_version)

        @info "found version change from $(old_version) to $(new_version)"

        # registering new package

        if is_version_valid 
            Pkg.develop(package_name)
            register(package_name)
        else
            throw("New version is invalid, please check the changes to version in Project.toml")
        end

        return new_version
    end
end
main()