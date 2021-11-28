cmake_minimum_required(VERSION 3.8.11)
project (bartty_opengl)

set(CMAKE_C_FLAGS "-g -Wall -O3")

set(sources

)
set(MAIN_LIBRARIES
  #stb
)

include_directories(include)

add_executable(main ${source} src/main.c)
target_link_libraries(main ${MAIN_LIBRARIES})

set(tests 
  ${source}
)

#add_executable(run_tests ${tests})
#target_link_libraries(run_tests ${MAIN_LIBRARIES} check)
