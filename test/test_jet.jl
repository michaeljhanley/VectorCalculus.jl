using JET
using VectorCalculus

const JET_FULLY_AVAILABLE = isdefined(JET, :JET_AVAILABLE) ? JET.JET_AVAILABLE : true

if JET_FULLY_AVAILABLE
    @testset "Code quality (JET.jl)" begin
        JET.test_package(
            VectorCalculus;
            target_modules=(VectorCalculus,),
            toplevel_logger=nothing,
        )
    end
else
    @info "Skipping JET static analysis: full JET functionality isn't available on Julia $(VERSION)."
end