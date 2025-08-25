import itertools

template_filename = 'template.xta'
road_conditions = ['DRY_ASPHALT', 'WET_COBBLESTONE', 'SNOW', 'ICE']
distances = ['20', '15', '10']
use_clamps = ['true']
max_torque = ['100', '200', '300', '900']

with open(template_filename, 'r') as f:
    template = f.read()

for road in road_conditions:
    for distance in distances:
        for clamp in use_clamps:
            for m in max_torque:
                # Replace placeholders
                model_content = template.replace('%ROAD_CONDITION%', road) \
                                        .replace('%DISTANCE%', distance) \
                                        .replace('%USE_CLAMP%', clamp) \
                                        .replace('%MAX_T%', m)
                
                filename = f'model_{distance}_{road}_{clamp}_{m}.xta'
                with open(filename, 'w') as f_out:
                    f_out.write(model_content)
