ROAD_CONDITIONS := DRY_ASPHALT WET_COBBLESTONE SNOW ICE
DISTANCES := 20 15 10
USE_CLAMPS := true
MAX_TORQUE := 100 200 300 900

MODELS := $(foreach D,$(DISTANCES), \
			$(foreach R,$(ROAD_CONDITIONS), \
			$(foreach U,$(USE_CLAMPS), \
			$(foreach M,$(MAX_TORQUE), \
				model_$(D)_$(R)_$(U)_$(M).xta))))

RESULTS := $(patsubst model_%.xta,results_%,$(MODELS))

.PHONY: all
all: aggregated_results.csv
	echo $(MODELS)

.models.stamp: template.xta generate_models.py
	python generate_models.py
	@touch $@

# Models depend on the stamp file
$(MODELS): .models.stamp

# Generate results files
results_%: model_%.xta query.q
#	echo $@
	/opt/uppaal/lib/app/bin/verifyta --alpha 0.03 --beta 0.03 --epsilon 0.03 $< query.q > $@

aggregated_results.csv: $(RESULTS)
	python generate_results.py $^ > $@

.PHONY: clean
clean:
	rm -f $(MODELS) $(RESULTS) .models.stamp aggregated_results.csv
