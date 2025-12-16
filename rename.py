import os

folder_path = "/home/iccsadmin/Portal_Data/Aakash_Institute/APR_Clean/"

for filename in os.listdir(folder_path):
    old_path = os.path.join(folder_path, filename)

    # Skip directories
    if not os.path.isfile(old_path):
        continue

    # Process only files that contain '%'
    if "%" in filename:
        # Keep everything from % onwards and prefix with RBI
        new_filename = "Aakash_Institute" + filename[filename.index("%"):]
        new_path = os.path.join(folder_path, new_filename)

        print(f"Renaming: {filename} → {new_filename}")
        os.rename(old_path, new_path)

print("Done!")
