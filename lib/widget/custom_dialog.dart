import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class RatingDialog extends StatefulWidget {
  RatingDialog({super.key, required this.onPressed, this.stars});

  dynamic onPressed;
  int? stars;

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _stars = 0;

  @override
  void initState() {
    super.initState();
    _stars = widget.stars ?? 0;
  }

  Widget _buildStar(int starCount) {
    return Padding(
      padding: starCount >= 5 ? const EdgeInsets.all(0) : const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: () {
          setState(() {
            _stars = starCount;
          });
        },
        child: _stars >= starCount ? SvgPicture.asset('assets/images/svg/star filled.svg', height: 18, width: 18) : SvgPicture.asset('assets/images/svg/star.svg', height: 18, width: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 340,
        height: 200,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text("Rate This Recipe", style:TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildStar(1),
                _buildStar(2),
                _buildStar(3),
                _buildStar(4),
                _buildStar(5),
              ],
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => setState(() {
                _stars = 0;
              }),
              child: const Text("Reset", style: TextStyle(color: Colors.red)),
            ),
            const Spacer(),
            Row(
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => widget.onPressed(_stars),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: HexColor("#FF9E0C")
                    ),
                    child: const Text("Apply", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))
                  ),
                ),
                const SizedBox(width: 5),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(), 
                  child: const Text("Close", style: TextStyle(color: Color(0xFF242424), fontWeight: FontWeight.w600))
                ),
                const SizedBox(width: 20)
              ]
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

class ConfirmDialog extends StatefulWidget {
  ConfirmDialog({super.key, this.label, required this.onConfirm});

  dynamic onConfirm;
  String? label;

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 340,
        height: 140,
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text(widget.label ?? "Are You Sure ?", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const Spacer(),
            Row(
              children: [
                const SizedBox(width: 20),
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onConfirm,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: HexColor("#FF9E0C")
                    ),
                    child: const Text("Yes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(), 
                  child: const Text("Cancel", style: TextStyle(color: Color(0xFF242424), fontWeight: FontWeight.w600))
                ),
                const SizedBox(width: 20)
              ]
            ),
            const SizedBox(height: 15),
          ],
        )
      )
    );
  }
}