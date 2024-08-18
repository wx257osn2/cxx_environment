FROM ubuntu:24.04 as builder

ARG GCC_VERSION=14
ARG LLVM_VERSION=19
ENV UBUNTU_CODENAME=noble

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && apt-get upgrade -y

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get install -y --no-install-recommends ca-certificates curl gnupg

RUN mkdir -p /usr/local/share/keyrings
RUN curl --tlsv1.2 -sSf https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor -o /usr/local/share/keyrings/llvm-snapshot-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/local/share/keyrings/llvm-snapshot-archive-keyring.gpg] http://apt.llvm.org/${UBUNTU_CODENAME}/ llvm-toolchain-${UBUNTU_CODENAME}-${LLVM_VERSION} main" >> /etc/apt/sources.list.d/llvm.list
RUN echo "deb-src [signed-by=/usr/local/share/keyrings/llvm-snapshot-archive-keyring.gpg] http://apt.llvm.org/${UBUNTU_CODENAME}/ llvm-toolchain-${UBUNTU_CODENAME}-${LLVM_VERSION} main" >> /etc/apt/sources.list.d/llvm.list
RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get install -y --no-install-recommends g++-${GCC_VERSION} make pkg-config
RUN update-alternatives --install /usr/local/bin/gcc        gcc        /usr/bin/gcc-${GCC_VERSION} ${GCC_VERSION} \
                        --slave   /usr/local/bin/g++        g++        /usr/bin/g++-${GCC_VERSION} \
                        --slave   /usr/local/bin/cpp        cpp        /usr/bin/cpp-${GCC_VERSION} \
                        --slave   /usr/local/bin/gcc-ar     gcc-ar     /usr/bin/gcc-ar-${GCC_VERSION} \
                        --slave   /usr/local/bin/gcc-nm     gcc-nm     /usr/bin/gcc-nm-${GCC_VERSION} \
                        --slave   /usr/local/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-${GCC_VERSION} \
                        --slave   /usr/local/bin/gcov       gcov       /usr/bin/gcov-${GCC_VERSION} \
                        --slave   /usr/local/bin/gcov-dump  gcov-dump  /usr/bin/gcov-dump-${GCC_VERSION} \
                        --slave   /usr/local/bin/gcov-tool  gcov-tool  /usr/bin/gcov-tool-${GCC_VERSION} \
                        --slave   /usr/local/bin/lto-dump   lto-dump   /usr/bin/lto-dump-${GCC_VERSION}
# Fix libstdc++ of g++-14.1 for clang++-19
# this will be able to be removed with g++-14.2
# see. https://github.com/llvm/llvm-project/issues/92586, https://gcc.gnu.org/bugzilla/show_bug.cgi?id=115119
RUN sed -i /usr/include/c++/14/bits/unicode.h -e 's/++this/++*this/g'

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get install -y --no-install-recommends llvm-${LLVM_VERSION}-dev clang-${LLVM_VERSION} clang-tools-${LLVM_VERSION} libclang-${LLVM_VERSION}-dev clangd-${LLVM_VERSION} clang-tidy-${LLVM_VERSION} libclang-rt-${LLVM_VERSION}-dev  libpolly-${LLVM_VERSION}-dev libfuzzer-${LLVM_VERSION}-dev lldb-${LLVM_VERSION} lld-${LLVM_VERSION} libc++-${LLVM_VERSION}-dev libc++abi-${LLVM_VERSION}-dev libomp-${LLVM_VERSION}-dev libunwind-${LLVM_VERSION}-dev libmlir-${LLVM_VERSION}-dev mlir-${LLVM_VERSION}-tools libbolt-${LLVM_VERSION}-dev bolt-${LLVM_VERSION}
RUN update-alternatives --install /usr/local/bin/clang clang /usr/bin/clang-${LLVM_VERSION} ${LLVM_VERSION} \
                        --slave   /usr/local/bin/FileCheck FileCheck /usr/bin/FileCheck-${LLVM_VERSION} \
                        --slave   /usr/local/bin/UnicodeNameMappingGenerator UnicodeNameMappingGenerator /usr/bin/UnicodeNameMappingGenerator-${LLVM_VERSION} \
                        --slave   /usr/local/bin/amdgpu-arch amdgpu-arch /usr/bin/amdgpu-arch-${LLVM_VERSION} \
                        --slave   /usr/local/bin/analyze-build analyze-build /usr/bin/analyze-build-${LLVM_VERSION} \
                        --slave   /usr/local/bin/asan_symbolize asan_symbolize /usr/bin/asan_symbolize-${LLVM_VERSION} \
                        --slave   /usr/local/bin/bugpoint bugpoint /usr/bin/bugpoint-${LLVM_VERSION} \
                        --slave   /usr/local/bin/c-index-test c-index-test /usr/bin/c-index-test-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang++ clang++ /usr/bin/clang++-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-apply-replacements clang-apply-replacements /usr/bin/clang-apply-replacements-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-change-namespace clang-change-namespace /usr/bin/clang-change-namespace-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-check clang-check /usr/bin/clang-check-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-cl clang-cl /usr/bin/clang-cl-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-cpp clang-cpp /usr/bin/clang-cpp-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-doc clang-doc /usr/bin/clang-doc-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-extdef-mapping clang-extdef-mapping /usr/bin/clang-extdef-mapping-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-include-cleaner clang-include-cleaner /usr/bin/clang-include-cleaner-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-include-fixer clang-include-fixer /usr/bin/clang-include-fixer-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-linker-wrapper clang-linker-wrapper /usr/bin/clang-linker-wrapper-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-move clang-move /usr/bin/clang-move-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-offload-bundler clang-offload-bundler /usr/bin/clang-offload-bundler-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-offload-packager clang-offload-packager /usr/bin/clang-offload-packager-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-pseudo clang-pseudo /usr/bin/clang-pseudo-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-query clang-query /usr/bin/clang-query-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-refactor clang-refactor /usr/bin/clang-refactor-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-rename clang-rename /usr/bin/clang-rename-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-reorder-fields clang-reorder-fields /usr/bin/clang-reorder-fields-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-repl clang-repl /usr/bin/clang-repl-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-scan-deps clang-scan-deps /usr/bin/clang-scan-deps-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-tblgen clang-tblgen /usr/bin/clang-tblgen-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-${LLVM_VERSION} \
                        --slave   /usr/local/bin/clang-tidy-diff.py clang-tidy-diff.py /usr/bin/clang-tidy-diff-${LLVM_VERSION}.py \
                        --slave   /usr/local/bin/clangd clangd /usr/bin/clangd-${LLVM_VERSION} \
                        --slave   /usr/local/bin/count count /usr/bin/count-${LLVM_VERSION} \
                        --slave   /usr/local/bin/diagtool diagtool /usr/bin/diagtool-${LLVM_VERSION} \
                        --slave   /usr/local/bin/dsymutil dsymutil /usr/bin/dsymutil-${LLVM_VERSION} \
                        --slave   /usr/local/bin/find-all-symbols find-all-symbols /usr/bin/find-all-symbols-${LLVM_VERSION} \
                        --slave   /usr/local/bin/hmaptool hmaptool /usr/bin/hmaptool-${LLVM_VERSION} \
                        --slave   /usr/local/bin/hwasan_symbolize hwasan_symbolize /usr/bin/hwasan_symbolize-${LLVM_VERSION} \
                        --slave   /usr/local/bin/intercept-build intercept-build /usr/bin/intercept-build-${LLVM_VERSION} \
                        --slave   /usr/local/bin/ld.lld ld.lld /usr/bin/ld.lld-${LLVM_VERSION} \
                        --slave   /usr/local/bin/ld64.lld ld64.lld /usr/bin/ld64.lld-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llc llc /usr/bin/llc-${LLVM_VERSION} \
                        --slave   /usr/local/bin/lld lld /usr/bin/lld-${LLVM_VERSION} \
                        --slave   /usr/local/bin/lld-link lld-link /usr/bin/lld-link-${LLVM_VERSION} \
                        --slave   /usr/local/bin/lldb lldb /usr/bin/lldb-${LLVM_VERSION} \
                        --slave   /usr/local/bin/lldb-argdumper lldb-argdumper /usr/bin/lldb-argdumper-${LLVM_VERSION} \
                        --slave   /usr/local/bin/lldb-instr lldb-instr /usr/bin/lldb-instr-${LLVM_VERSION} \
                        --slave   /usr/local/bin/lldb-server lldb-server /usr/bin/lldb-server-${LLVM_VERSION} \
                        --slave   /usr/local/bin/lldb-vscode lldb-vscode /usr/bin/lldb-vscode-${LLVM_VERSION} \
                        --slave   /usr/local/bin/lli lli /usr/bin/lli-${LLVM_VERSION} \
                        --slave   /usr/local/bin/lli-child-target lli-child-target /usr/bin/lli-child-target-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-PerfectShuffle llvm-PerfectShuffle /usr/bin/llvm-PerfectShuffle-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-addr2line llvm-addr2line /usr/bin/llvm-addr2line-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-ar llvm-ar /usr/bin/llvm-ar-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-as llvm-as /usr/bin/llvm-as-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-bcanalyzer llvm-bcanalyzer /usr/bin/llvm-bcanalyzer-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-bitcode-strip llvm-bitcode-strip /usr/bin/llvm-bitcode-strip-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-bolt llvm-bolt /usr/bin/llvm-bolt-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-bolt-heatmap llvm-bolt-heatmap /usr/bin/llvm-bolt-heatmap-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-boltdiff llvm-boltdiff /usr/bin/llvm-boltdiff-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-c-test llvm-c-test /usr/bin/llvm-c-test-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-cat llvm-cat /usr/bin/llvm-cat-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-cfi-verify llvm-cfi-verify /usr/bin/llvm-cfi-verify-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-config llvm-config /usr/bin/llvm-config-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-cov llvm-cov /usr/bin/llvm-cov-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-cvtres llvm-cvtres /usr/bin/llvm-cvtres-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-cxxdump llvm-cxxdump /usr/bin/llvm-cxxdump-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-cxxfilt llvm-cxxfilt /usr/bin/llvm-cxxfilt-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-cxxmap llvm-cxxmap /usr/bin/llvm-cxxmap-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-debuginfo-analyzer llvm-debuginfo-analyzer /usr/bin/llvm-debuginfo-analyzer-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-debuginfod llvm-debuginfod /usr/bin/llvm-debuginfod-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-debuginfod-find llvm-debuginfod-find /usr/bin/llvm-debuginfod-find-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-diff llvm-diff /usr/bin/llvm-diff-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-dis llvm-dis /usr/bin/llvm-dis-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-dlltool llvm-dlltool /usr/bin/llvm-dlltool-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-dwarfdump llvm-dwarfdump /usr/bin/llvm-dwarfdump-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-dwarfutil llvm-dwarfutil /usr/bin/llvm-dwarfutil-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-dwp llvm-dwp /usr/bin/llvm-dwp-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-exegesis llvm-exegesis /usr/bin/llvm-exegesis-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-extract llvm-extract /usr/bin/llvm-extract-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-gsymutil llvm-gsymutil /usr/bin/llvm-gsymutil-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-ifs llvm-ifs /usr/bin/llvm-ifs-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-install-name-tool llvm-install-name-tool /usr/bin/llvm-install-name-tool-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-jitlink llvm-jitlink /usr/bin/llvm-jitlink-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-jitlink-executor llvm-jitlink-executor /usr/bin/llvm-jitlink-executor-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-lib llvm-lib /usr/bin/llvm-lib-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-libtool-darwin llvm-libtool-darwin /usr/bin/llvm-libtool-darwin-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-link llvm-link /usr/bin/llvm-link-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-lipo llvm-lipo /usr/bin/llvm-lipo-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-lto llvm-lto /usr/bin/llvm-lto-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-lto2 llvm-lto2 /usr/bin/llvm-lto2-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-mc llvm-mc /usr/bin/llvm-mc-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-mca llvm-mca /usr/bin/llvm-mca-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-ml llvm-ml /usr/bin/llvm-ml-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-modextract llvm-modextract /usr/bin/llvm-modextract-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-mt llvm-mt /usr/bin/llvm-mt-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-nm llvm-nm /usr/bin/llvm-nm-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-objcopy llvm-objcopy /usr/bin/llvm-objcopy-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-objdump llvm-objdump /usr/bin/llvm-objdump-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-omp-device-info llvm-omp-device-info /usr/bin/llvm-omp-device-info-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-omp-kernel-replay llvm-omp-kernel-replay /usr/bin/llvm-omp-kernel-replay-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-opt-report llvm-opt-report /usr/bin/llvm-opt-report-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-otool llvm-otool /usr/bin/llvm-otool-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-pdbutil llvm-pdbutil /usr/bin/llvm-pdbutil-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-profdata llvm-profdata /usr/bin/llvm-profdata-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-profgen llvm-profgen /usr/bin/llvm-profgen-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-ranlib llvm-ranlib /usr/bin/llvm-ranlib-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-rc llvm-rc /usr/bin/llvm-rc-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-readelf llvm-readelf /usr/bin/llvm-readelf-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-readobj llvm-readobj /usr/bin/llvm-readobj-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-reduce llvm-reduce /usr/bin/llvm-reduce-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-remark-size-diff llvm-remark-size-diff /usr/bin/llvm-remark-size-diff-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-remarkutil llvm-remarkutil /usr/bin/llvm-remarkutil-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-rtdyld llvm-rtdyld /usr/bin/llvm-rtdyld-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-sim llvm-sim /usr/bin/llvm-sim-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-size llvm-size /usr/bin/llvm-size-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-split llvm-split /usr/bin/llvm-split-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-stress llvm-stress /usr/bin/llvm-stress-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-strings llvm-strings /usr/bin/llvm-strings-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-strip llvm-strip /usr/bin/llvm-strip-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-symbolizer llvm-symbolizer /usr/bin/llvm-symbolizer-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-tapi-diff llvm-tapi-diff /usr/bin/llvm-tapi-diff-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-tblgen llvm-tblgen /usr/bin/llvm-tblgen-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-tli-checker llvm-tli-checker /usr/bin/llvm-tli-checker-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-undname llvm-undname /usr/bin/llvm-undname-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-windres llvm-windres /usr/bin/llvm-windres-${LLVM_VERSION} \
                        --slave   /usr/local/bin/llvm-xray llvm-xray /usr/bin/llvm-xray-${LLVM_VERSION} \
                        --slave   /usr/local/bin/merge-fdata merge-fdata /usr/bin/merge-fdata-${LLVM_VERSION} \
                        --slave   /usr/local/bin/mlir-cpu-runner mlir-cpu-runner /usr/bin/mlir-cpu-runner-${LLVM_VERSION} \
                        --slave   /usr/local/bin/mlir-linalg-ods-yaml-gen mlir-linalg-ods-yaml-gen /usr/bin/mlir-linalg-ods-yaml-gen-${LLVM_VERSION} \
                        --slave   /usr/local/bin/mlir-lsp-server mlir-lsp-server /usr/bin/mlir-lsp-server-${LLVM_VERSION} \
                        --slave   /usr/local/bin/mlir-opt mlir-opt /usr/bin/mlir-opt-${LLVM_VERSION} \
                        --slave   /usr/local/bin/mlir-pdll mlir-pdll /usr/bin/mlir-pdll-${LLVM_VERSION} \
                        --slave   /usr/local/bin/mlir-pdll-lsp-server mlir-pdll-lsp-server /usr/bin/mlir-pdll-lsp-server-${LLVM_VERSION} \
                        --slave   /usr/local/bin/mlir-reduce mlir-reduce /usr/bin/mlir-reduce-${LLVM_VERSION} \
                        --slave   /usr/local/bin/mlir-tblgen mlir-tblgen /usr/bin/mlir-tblgen-${LLVM_VERSION} \
                        --slave   /usr/local/bin/mlir-translate mlir-translate /usr/bin/mlir-translate-${LLVM_VERSION} \
                        --slave   /usr/local/bin/modularize modularize /usr/bin/modularize-${LLVM_VERSION} \
                        --slave   /usr/local/bin/not not /usr/bin/not-${LLVM_VERSION} \
                        --slave   /usr/local/bin/nvptx-arch nvptx-arch /usr/bin/nvptx-arch-${LLVM_VERSION} \
                        --slave   /usr/local/bin/obj2yaml obj2yaml /usr/bin/obj2yaml-${LLVM_VERSION} \
                        --slave   /usr/local/bin/opt opt /usr/bin/opt-${LLVM_VERSION} \
                        --slave   /usr/local/bin/perf2bolt perf2bolt /usr/bin/perf2bolt-${LLVM_VERSION} \
                        --slave   /usr/local/bin/pp-trace pp-trace /usr/bin/pp-trace-${LLVM_VERSION} \
                        --slave   /usr/local/bin/run-clang-tidy run-clang-tidy /usr/bin/run-clang-tidy-${LLVM_VERSION} \
                        --slave   /usr/local/bin/run-clang-tidy.py run-clang-tidy.py /usr/bin/run-clang-tidy-${LLVM_VERSION}.py \
                        --slave   /usr/local/bin/sancov sancov /usr/bin/sancov-${LLVM_VERSION} \
                        --slave   /usr/local/bin/sanstats sanstats /usr/bin/sanstats-${LLVM_VERSION} \
                        --slave   /usr/local/bin/scan-build scan-build /usr/bin/scan-build-${LLVM_VERSION} \
                        --slave   /usr/local/bin/scan-build-py scan-build-py /usr/bin/scan-build-py-${LLVM_VERSION} \
                        --slave   /usr/local/bin/scan-view scan-view /usr/bin/scan-view-${LLVM_VERSION} \
                        --slave   /usr/local/bin/split-file split-file /usr/bin/split-file-${LLVM_VERSION} \
                        --slave   /usr/local/bin/tblgen-lsp-server tblgen-lsp-server /usr/bin/tblgen-lsp-server-${LLVM_VERSION} \
                        --slave   /usr/local/bin/verify-uselistorder verify-uselistorder /usr/bin/verify-uselistorder-${LLVM_VERSION} \
                        --slave   /usr/local/bin/wasm-ld wasm-ld /usr/bin/wasm-ld-${LLVM_VERSION} \
                        --slave   /usr/local/bin/yaml-bench yaml-bench /usr/bin/yaml-bench-${LLVM_VERSION} \
                        --slave   /usr/local/bin/yaml2obj yaml2obj /usr/bin/yaml2obj-${LLVM_VERSION}

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get install -y --no-install-recommends libboost-all-dev


FROM ubuntu:24.04 as final

COPY --from=builder /usr /usr
COPY --from=builder /etc/alternatives /etc/alternatives
