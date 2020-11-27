echo
echo "========================================"
echo "Running tests"
echo "----------------------------------------"
(
	make ibex/configure
	make all DEVICE=${DEVICE} PARTNAME=${PARTNAME} PCF=${PCF} SDC=${SDC} XDC=${XDC}
)
echo "----------------------------------------"
