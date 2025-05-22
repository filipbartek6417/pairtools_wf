version 1.0

task pairtools_task {
    input {
        File aligned
        File genome
        String container
    }

    command <<<
        pairtools --help
    >>>

    output {}

    runtime {
        cpu: 32
        memory: "100G"
        disks: "local-disk 2000 SSD"
        docker: container
    }
}

workflow pairtools_wf {
  input {
    String container = "ubuntu:latest"
  }

  call pairtools_task {
    input:
      aligned = aligned,
      genome = genome,
      container = container
  }

  output {}
}
