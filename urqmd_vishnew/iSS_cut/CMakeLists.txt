aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/src source_file)

add_executable(iSS_cut ${source_file})

INSTALL(TARGETS iSS_cut DESTINATION urqmd_vishnew/iSS)
INSTALL(FILES cut_para.txt DESTINATION urqmd_vishnew/iSS)