version 1.0

task pairtools_task {
    input {
        File aligned
        File genome
        String container
    }

    command <<<
        pairtools parse2 --min-mapq 40 --max-inter-align-gap 30 --nproc-in 8 --nproc-out 8 --chroms-path ~{genome} ~{aligned} > parsed.pairsam
        mkdir /home/temp
        pairtools sort --nproc 16 --tmpdir=/home/temp/  parsed.pairsam > sorted.pairsam
        pairtools dedup --nproc-in 8 --nproc-out 8 --mark-dups --output-stats stats.txt --output dedup.pairsam sorted.pairsam
    >>>

    output {
        File stats = "stats.txt"
    }

    runtime {
        cpu: 32
        memory: "100G"
        disks: "local-disk 2000 SSD"
        docker: container
    }
}

workflow pairtools_wf {
  input {
    File aligned = "gs://fc-c3eed389-0be2-4bbc-8c32-1a40b8696969/submissions/5646ab28-9144-42af-8d4d-93ebe9e0942c/porec_qc/e466ed5e-fcdb-4e3c-bfa6-7fadc23540b2/call-minimap2_align/aligned.sam"
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
      File stats = pairtools_task.stats
  }
}
