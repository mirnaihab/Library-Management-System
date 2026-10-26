# Copies are a count, not individual copies

A book stores only how many copies the library owns. Available copies is always calculated as copies − open loans − holds, and never stored. No story names a specific physical copy (no barcodes, no condition per copy), and a stored availability number could drift out of sync with the actual loans and holds. Tracking individual copies later would mean a `Copy` entity that loans and holds point to, and that change would touch every borrow, return, hold and edit rule.
