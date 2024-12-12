---
name: Mount request
about: Suggest an idea for a new mount
title: '[mount] '
labels: 'mount request'
assignees: ''
---

**What's the name of the mount?**

Provide both the name of the mount and some cameras/lenses that use that system.

**Do you have models for the mount?**

Provide either a link to an existing one or upload them to the issue. Models must be STL format, and without issue. All models must be oriented with the taking side pointing up, as if the camera was lying on it's back. All models must be centered horizontally. Vertically, male models should have it's top edge flush with the XY plane (below 0), female models should have it's bottom edge flush with the XY plane (above 0). _Submitting a model that doesn't meet these criteria will lower it's chances of being added_

**Fill out the table below the best you can**

The example provided is for a Sony E Mount. All numbers are in millimeters. _Duplicate this table for each model you're attaching._

| Field              | Description                                                                        | Example                                                     | Value |
| ------------------ | ---------------------------------------------------------------------------------- | ----------------------------------------------------------- | ----- |
| `group`            | Typically the brand that's most associated with the mount                          | Sony                                                        |       |
| `name`             | The name of the mount                                                              | E Mount                                                     |       |
| `thickness`        | How much of the model contributes to the flange distance                           | 2.4                                                         |       |
| `inner_diameter`   | The diameter of the inside of the mount model                                      | 41.5                                                        |       |
| `outer_diameter`   | The diameter of the outside of the mount model                                     | 61                                                          |       |
| `flange`           | flange focal distance of the mount system                                          | 18                                                          |       |
| `attribution_link` | If the model requires attribution in it's license, link to where you found it here | https://www.printables.com/model/143762-sony-efe-lens-mount |       |
| `attribution_text` | If the model requires attribution, create a blurb to provide proper attribution    | From @thenickdude on Printables                             |       |

**Implementation Checklist**

This section is for maintainers:

[ ] Request has necessary information

[ ] Request has models

[ ] Models are centered

[ ] Models are manifold and work in OpenSCAD

[ ] Models are properly placed on the Z Axis

[ ] Mount(s) have been added to data.json

[ ] Mount(s) have been tested

[ ] Request has been merged
