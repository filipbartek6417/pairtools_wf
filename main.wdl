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
        docker: ~{container}
    }
}

workflow pairtools_wf {
  input {
    File aligned = "gs://fc-c3eed389-0be2-4bbc-8c32-1a40b8696969/submissions/5646ab28-9144-42af-8d4d-93ebe9e0942c/porec_qc/e466ed5e-fcdb-4e3c-bfa6-7fadc23540b2/call-minimap2_align/aligned.sam"
    File genome = "gs://fc-c3eed389-0be2-4bbc-8c32-1a40b8696969/bartek_testing/hs1_ref/hs1.genome"
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
