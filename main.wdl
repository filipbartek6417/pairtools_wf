version 1.0

task pairtools_task {
    input {
        String container
    }

    command <<<
        mkdir /home/temp
        df -h
        touch sorted.pairsam
    >>>

    output {
        File sorted = "sorted.pairsam"
    }

    runtime {
        cpu: 32
        memory: "200G"
        disks: "local-disk 20000 SSD"
        docker: container
    }
}

workflow pairtools_wf {
  input {
    String container = "quay.io/biocontainers/pairtools:1.1.3--py311h534e829_0"
  }

  call pairtools_task {
    input:
      container = container
  }

  output {
      File sorted = pairtools_task.sorted
  }
}
