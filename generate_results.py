import os
import re
import csv
import sys

HEADER = [
    'formula', 'file', 'distance', 'road condition', 'clamped', 'max_torque',
    'lb', 'ub', 'ci', "mean", "pm", 's_runs', 'tot_runs'
]

def parse_filename(filename):
    base = os.path.basename(filename)
    if not base.startswith('results_'):
        return None, None, None
    
    parts = base[8:].split('_')  # Remove 'results_' prefix
    if len(parts) < 3:
        return None, None, None
    
    distance = parts[0]
    clamp = parts[-2]
    max_t = parts[-1]
    road = '_'.join(parts[1:-2]).replace('_', ' ')
    return distance, road, clamp, max_t

def process_file(filename, writer):
    distance, road, clamp, max_t = parse_filename(filename)
    if not all([distance, road, clamp]):
        return
    
    current_formula = None
    with open(filename, 'r') as f:
        for line in f:
            line = line.strip()
            
            # Formula detection
            formula_match = re.match(
                r'^Verifying formula (\d+) at (.*?\.q:\d+)', 
                line
            )

            if formula_match:
                current_formula = formula_match.group(1)
                current_query = formula_match.group(2)
                current_type = None
                current_data = {}
                continue
                
            if current_formula:
                # Detect query type if not set
                if not current_type:
                    if 'Pr(' in line:
                        current_type = 'probability'
                        pr_match = re.search(
                            r'\((\d+)/(\d+) runs\).*?\[([0-9.]+),([0-9.]+)\].*?(\d+)% CI', 
                            line
                        )
                        if pr_match:
                            current_data.update({
                                'runs': pr_match.group(1),
                                'tot_runs': pr_match.group(2),
                                'lb': pr_match.group(3),
                                'ub': pr_match.group(4),
                                'ci': pr_match.group(5)
                            })
                    elif 'E(' in line:
                        current_type = 'estimation'
                        print(line, file=sys.stderr)
                        match = re.search(r'\((\d+) runs\) E\(\w+\) = ([\d\.]+) ± ([\d\.e\-\+]+) \((\d+)% CI\)', line)
                        print(match, file=sys.stderr)
                        
                        current_data['runs'] = match.group(1)
                        current_data["mean"] = match.group(2)
                        current_data["pm"] = match.group(3)
                        current_data['ci'] = match.group(4)
            
                    continue
                
                # Process based on query type
                if current_type == 'probability':
                    # Look for mean in values line
                    mean_match = re.search(r'mean=([0-9.]+)', line)
                    if mean_match and 'mean' not in current_data:
                        current_data['mean'] = mean_match.group(1)
                        # Write when we have all data
                        if all(k in current_data for k in ['lb', 'ub']):
                            writer.writerow([
                                current_formula,
                                current_query,
                                distance,
                                road,
                                clamp,
                                current_data['lb'],
                                current_data['ub'],
                                current_data['ci'],
                                current_data['mean'],
                                '',
                                current_data['runs'],
                                current_data['tot_runs']
                            ])
                            current_formula = None
                            
                elif current_type == 'estimation':
                    # Extract values from values line
                    values_match = re.search(
                        r'Values in \[([0-9.]+),([0-9.]+)\].*?mean=([0-9.]+)',
                        line
                    )
                    if values_match:
                        current_data.update({
                            'lb': values_match.group(1),
                            'ub': values_match.group(2)
                        })
                        # Write when we have all data
                        if all(k in current_data for k in ['lb']):
                            writer.writerow([
                                current_formula,
                                current_query,
                                distance,
                                road,
                                clamp,
                                max_t,
                                current_data['lb'],
                                current_data['ub'],
                                current_data['ci'],
                                current_data['mean'],
                                current_data["pm"],
                                '-1',
                                current_data['runs']
                            ])
                            current_formula = None

def main():
    writer = csv.writer(sys.stdout)
    writer.writerow(HEADER)
    
    for filename in sys.argv[1:]:
        process_file(filename, writer)

if __name__ == '__main__':
    main()
