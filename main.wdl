version 1.0

task pairtools_task {
    input {
        File aligned
        File genome
        String container
    }

    command <<<
        pairtools parse2 --min-mapq 40 --max-inter-align-gap 30 --nproc-in 8 --nproc-out 8 --chroms-path ~{genome} ~{aligned} > parsed.pairsam
    >>>

    output {
        File parsed = "parsed.pairsam"
    }

    runtime {
        cpu: 32
        memory: "200G"
        disks: "local-disk 5000 SSD"
        docker: container
    }
}

workflow pairtools_wf {
  input {
    File aligned = "gs://fc-c3eed389-0be2-4bbc-8c32-1a40b8696969/submissions/0403f7e5-bf00-4b07-89a5-9cc18e72022a/bwa_alignment/687fa25b-a6ad-4f8f-a722-48171019296c/call-align_with_bwa/aligned.sam"
    File genome = "gs://fc-c3eed389-0be2-4bbc-8c32-1a40b8696969/bartek_testing/hs1_ref/hs1.genome"
    String container = "quay.io/biocontainers/pairtools:1.1.3--py311h534e829_0"
  }

  call pairtools_task {
    input:
      aligned = aligned,
      genome = genome,
      container = container
  }

  output {
      File parsed = pairtools_task.parsed
  }
}
