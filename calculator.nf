
process use_bc {
    input:
        val str

    output:
        stdout

    """
    echo ${str} | bc
    """
}

workflow {
    // load value from calculator_params.yaml
    math_str = params.math_string

    // output from use_bc() goes into result channel
    result = use_bc(math_str)
    result.view()
}


