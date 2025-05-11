UCBShift v2
===========

Docker image builder for UCBShift v2 from THGLab/CSpred:SideChain

Please note that the new UCBShift v2 [models](https://zenodo.org/records/15375968) will still have to be downloaded separately. The folder storing the models can be linked while running UCBShift V2 through the Docker container.

Ensure you have the [latest](https://docs.docker.com/engine/install/) Docker Engine installed.

Building and running locally
----------------------------
Clone this repository:
```
git clone https://github.com/menoliu/UCBShiftv2
```

Enter the repository and build locally:
```
cd UCBShiftv2
docker build -t cspred .
```

Make sure you have downloaded and extracted the models mentioned above and mount the folder while running ``cspred``:
```
docker run -it --rm -v ~/Downloads/models:/opt/CSpred/models \
    -v "$(pwd)/conformers":/data -w /opt/CSpred cspred:latest \
    /data/conformer_1.pdb -o /data/conf1_cspred.csv
```

The above command will run UCBShift for ``conformer_1.pdb`` and save the results as ``conf1_cspred.csv``. Please change the paths according to your model and working directories.

For more documentation on running UCBShift and its options please refer to the [documentation](https://github.com/THGLab/CSpred/blob/SideChain/README.md). Different flags/parameters can be made on the last line.

Pulling and running a pre-built image
-------------------------------------
GitHub workflows can automatically build and publish new images.

Pull the image using docker:
```
docker pull ghcr.io/menoliu/ucbshiftv2:main
```

However the name of the image will need to be changed. The default usage is:
```
docker run -it --rm -v ~/Downloads/models:/opt/CSpred/models \
    -v "$(pwd)/conformers":/data -w /opt/CSpred ghcr.io/menoliu/ucbshiftv2:main \
    /data/conformer_1.pdb -o /data/conf1_cspred.csv
```

Citations
=========
Ptaszek, A. L., Li, J., Konrat R., Platzer G., Head-Gordon, T. (2024). UCBShift 2.0: Bridging the Gap from Backbone to Side Chain Protein Chemical Shift Prediction for Protein Structures. _Journal of the American Chemical Society_ 146(46), 31733-31745.DOI: [10.1021/jacs.4c10474](https://pubs.acs.org/doi/abs/10.1021/jacs.4c10474)

Li, J., Bennett, K. C., Liu, Y., Martin, M. V., & Head-Gordon, T. (2020). Accurate prediction of chemical shifts for aqueous protein structure on “Real World” data. _Chemical Science_, 11(12), 3180-3191. DOI: [10.1039/C9SC06561J](https://pubs.rsc.org/en/content/articlehtml/2020/sc/c9sc06561j)
