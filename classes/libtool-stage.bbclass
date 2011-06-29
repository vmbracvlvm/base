# -*- mode:python; -*-

STAGE_FIXUP_FUNCS += "libtool_stage_fixup"

def libtool_stage_fixup(d):
    import glob

    stage_dir = os.path.realpath(d.getVar("STAGE_DIR", True))
    pkg_type = d.get("STAGE_FIXUP_PKG_TYPE")
    sysroot = os.path.join(stage_dir, pkg_type)
    recipe_type = d.get("RECIPE_TYPE")
    
    if pkg_type == "native":
        libdir = d.getVar("stage_libdir", True)
        base_libdir = d.getVar("stage_base_libdir", True)
    elif (pkg_type == "machine" or
          pkg_type == "sdk" and recipe_type in ("sdk", "sdk-cross")):
        libdir = d.getVar("target_libdir", True)
        base_libdir = d.getVar("target_base_libdir", True)
    else:
        libdir = d.getVar("libdir", True)
        base_libdir = d.getVar("base_libdir", True)
    
    lafiles = set(glob.glob("%s/*.la"%(libdir.lstrip("/")))).union(
                  glob.glob("%s/*.la"%(base_libdir.lstrip("/"))))
    for filename in lafiles:
        with open(filename, "r") as input_file:
            lafile = input_file.read()
        lafile = re.sub("-L%s"%(libdir),
                        "-L%s%s"%(sysroot, libdir), lafile)
        lafile = re.sub("-L%s"%(base_libdir),
                        "-L%s%s"%(sysroot, base_libdir), lafile)
        lafile = re.sub("libdir='%s'"%(libdir),
                        "libdir='%s%s'"%(sysroot, libdir), lafile)
        lafile = re.sub("libdir='%s'"%(base_libdir),
                        "libdir='%s%s'"%(sysroot, base_libdir), lafile)
        lafile = re.sub("([' ])%s"%(libdir),
                        r"\g<1>%s%s"%(sysroot, libdir), lafile)
        lafile = re.sub("([' ])%s"%(base_libdir),
                        r"\g<1>%s%s"%(sysroot, base_libdir), lafile)
        pattern = re.compile("^installed=yes", re.MULTILINE)
        lafile = re.sub(pattern, "installed=no", lafile)
        with open(filename, "w") as output_file:
            output_file.write(lafile)
        print "processed lafile", filename
