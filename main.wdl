version 1.0

task pairtools_task {
    input {
        File parsed
        String container
    }

    command <<<
        mkdir /home/temp
        pairtools sort --nproc 32 --tmpdir=/home/temp/ ~{parsed} > sorted.pairsam
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
    File parsed = "gs://fc-c3eed389-0be2-4bbc-8c32-1a40b8696969/submissions/21f6cdc5-b0f7-4bf2-bd7c-4ff6079fc9c0/pairtools_wf/ef8fc978-62ce-4b61-a0de-a471781f4afa/call-pairtools_task/parsed.pairsam"
    String container = "quay.io/biocontainers/pairtools:1.1.3--py311h534e829_0"
  }

  call pairtools_task {
    input:
      parsed = parsed,
      container = container
  }

  output {
      File sorted = pairtools_task.sorted
  }
}
