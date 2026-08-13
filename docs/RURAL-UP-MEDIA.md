# Rural UP Homepage Media

All files are self-hosted in `themes/rural-up-theme/img/editorial/` and used as editorial placeholders only. They do not depict named Rural UP properties.

## Theme editorial surfaces

| File | Source | License basis | Placement |
| --- | --- | --- | --- |
| `hero-countryside.jpg` | https://images.unsplash.com/photo-1470770841072-f978cf4d019e | Unsplash License | Homepage hero |
| `region-green-stay.jpg` | https://images.unsplash.com/photo-1473448912268-2022ce9509d8 | Unsplash License | Region editorial card |
| `region-landscape.jpg` | https://images.unsplash.com/photo-1501785888041-af3ef285b470 | Unsplash License | Region editorial card |
| `region-hills.jpg` | https://images.unsplash.com/photo-1464822759023-fed622ff2c3b | Unsplash License | Region editorial card |
| `activity-garden.jpg` | https://images.unsplash.com/photo-1497250681960-ef046c08a56e | Unsplash License | Activity editorial surface |
| `story-craft.jpg` | https://images.unsplash.com/photo-1465447142348-e9952c393450 | Unsplash License | Story fallback |

The Unsplash License permits commercial use without mandatory attribution. Source records are retained here for replacement and attribution governance.

## Client Demo Farmstays and Region Covers

The following local assets are representative editorial imagery for the client-demo farmstays and their regional covers. They do not depict the named properties and must be replaced with client-approved property photography before production launch. Source files are Wikimedia Commons uploads under free licenses; the `Source` link is the Commons file page and the exact license (and author, where required) follows the link.

| Local file | Subject | Author | License | Source (Commons) | Size used | Intended use |
| --- | --- | --- | --- | --- | --- | --- |
| `region-awadh.jpg` | Bara Imambara, Lucknow | Slyronit | CC BY-SA 4.0 | https://commons.wikimedia.org/wiki/File:Bara_Imambara,_Lucknow_2.jpg | 1600x900 | Awadh region cover (`demo-region-awadh.jpg`) |
| `region-bundelkhand.jpg` | Orchha Fort, Orchha | Skyographer | CC BY 4.0 | https://commons.wikimedia.org/wiki/File:ORCHHA_FORT,_ORCHHA,_MADHYA_PRADESH.jpg | 1600x900 | Bundelkhand region cover |
| `region-braj.jpg` | Prem Mandir, Vrindavan | Biswarup Ganguly | CC BY 3.0 | https://commons.wikimedia.org/wiki/File:Prem_Mandir_-_Vrindaban_2013-02-22_4834.JPG | 1600x900 | Braj region cover |
| `region-purvanchal.jpg` | Ram Janmabhoomi Mandir, Ayodhya | Prashant Kharote | CC BY-SA 4.0 | https://commons.wikimedia.org/wiki/File:Ram_janma_bhumi.jpg | 1600x900 | Purvanchal region cover |
| `region-rohilkhand.jpg` | Sal forest, Pilibhit Tiger Reserve | A. J. T. Johnsingh (WWF-India and NCF) | CC BY-SA 3.0 | https://commons.wikimedia.org/wiki/File:Magnificent_sal_forests_at_Pilibhit_Tiger_Reserve.jpg | 1600x900 | Rohilkhand region cover |
| `region-kashi.jpg` | Dashashwamedh Ghat, Varanasi | Sulagna | CC BY-SA 4.0 | https://commons.wikimedia.org/wiki/File:DASHASHWAMEDH_GHAT,_VARANASI.jpg | 1600x900 | Kashi region cover |
| `demo-gomti-mango-house.jpg` | Mango orchard, Lucknow | Zainab37 | CC BY-SA 4.0 | https://commons.wikimedia.org/wiki/File:Mango_orchard_in_Lucknow.jpg | 1600x1200 | Gomti Mango House covers |
| `demo-orchard-ridge.jpg` | Jhansi Fort | Pinakpani | CC BY-SA 4.0 | https://commons.wikimedia.org/wiki/File:Jhansi_Fort_of_Rani_Laxmibai_in_Jhansi_21.jpg | 1600x1200 | Orchard Ridge Farmstay covers |
| `demo-yamuna-courtyard.jpg` | Yamuna river, Vrindavan | Goutam1962 | CC BY-SA 4.0 | https://commons.wikimedia.org/wiki/File:Yamuna_river_and_devotees_of_Vrindavan_12.jpg | 1440x1080 | Yamuna Courtyard Farmstay covers |
| `demo-sarayu-fields.jpg` | River Saryu, Guptar Ghat, Ayodhya | Prashant Kharote | CC BY 4.0 | https://commons.wikimedia.org/wiki/File:River_Saryu,_Guptar_Ghat.jpg | 1600x1200 | Sarayu Fields Retreat covers |
| `demo-terai-wetlands.jpg` | Terai grassland (Dudhwa National Park) | Milena Roudna | CC BY-SA 4.0 | https://commons.wikimedia.org/wiki/File:Dudhwa_National_Park.jpg | 1600x1200 | Terai Wetlands Farmstay covers |
| `demo-ganga-looms.jpg` | Silk looms, Varanasi | Dan Ruth | CC BY 2.0 | https://commons.wikimedia.org/wiki/File:Silk_Looms,_Varanasi.jpg | 1600x1200 | Ganga Looms Country House covers |

Region covers are reproduced by the demo seed into `img/fhregions/demo-region-{slug}.jpg` (1600x900); hotel and room-product covers receive the `demo-*.jpg` files through the QloApps image pipeline. Templates never request third-party media at runtime.

## Licensing notes

- CC BY / CC BY-SA / CC BY 3.0-4.0 require attribution — the table above records author, license, and source for every asset. Replaced or removed assets must be dropped from the table at the same time.
- CC0 / Public domain assets need no attribution.
- The Unsplash-sourced theme surfaces remain covered by the Unsplash License.
- Refresh media after replacing assets: `podman exec qloapps_web_1 php /usr/local/bin/seed-rural-up-demo --refresh-images`