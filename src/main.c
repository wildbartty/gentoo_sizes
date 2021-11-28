#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <errno.h>
#include <fcntl.h>

/*
  * Gentoo dependency types
  * DEPEND   GENERIC dependency
  * BDEPEND Build time dependency
  * RDEPEND Runtime Dependency
  * IDEPEND Install Dependency // why not just have build dependency
  * PDEPEND Post dependencies // to beat the circulars
*/

struct package_node {
  char* name;
  char** deps;
};

void parse_deps(const char* filename, char*** var_ref) {
  // takes a directory name and sets var_ref to be a list of strings
  // that contain each of the dependencys of the package 
  struct stat statv;
  int chk;
  chk = stat(filename, &statv);
  if (chk != 0) {
    *var_ref = NULL;
    printf("error opening file: %s, errno: %s\n", filename, strerror(errno));
    return;
  }
  if (!(statv.st_mode & S_IFDIR)) {
    printf("st_mode is %o\n", statv.st_mode);
    printf("S_IFDIR is %o\n", S_IFDIR);
    puts("Error not directory");
    return;
  }
  int FD = open(filename, O_RDONLY|O_DIRECTORY);
}

int main() {
  /* FILE* world_file; */
  /* world_file = fopen("/var/lib/portage/world", "r"); */
  // get the new lines in the world file
  
  FILE* pipe = popen("cat /var/lib/portage/world | wc -l", "r");
  if (!pipe) {
    puts("popen fucked");
    return 1;
  }
  
  char cmd_buffer[256];
  // it is unreasonable for the user to have more packages than
  // are in the gentoo repos
  int num_pkgs;
  if (!feof(pipe)) {
    if (fgets(cmd_buffer,31,pipe) ==NULL) {
      puts("fgets fucked");
      return 2;
    }
  }
  num_pkgs = strtol(cmd_buffer, NULL, 10);
  pclose(pipe);
  
  char** world_packages = calloc(sizeof(char*), num_pkgs+2);
  
  FILE* world_file = fopen("/var/lib/portage/world", "r");

  for(int i=0; i < num_pkgs; i++) {
    fgets(cmd_buffer, 255, world_file);
    world_packages[i] = strdup(cmd_buffer);
  }
  fclose(world_file);

  struct package_node *package_nodes = calloc(sizeof(struct package_node), num_pkgs + 2);
  
  parse_deps("/home/wildbartty/", &package_nodes[0].deps);
  for(int i=0; i < num_pkgs; i++) {
    free(world_packages[i]);
  }

  free(world_packages);
  
  return 0;
}
