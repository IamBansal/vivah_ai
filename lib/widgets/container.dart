import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountsRow extends StatelessWidget {
  final String text;
  final String? bestFriendText;
  final VoidCallback? onPressed;

  const AccountsRow({
    Key? key,
    required this.text,
    this.bestFriendText,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle,
                size: 30,
                color: Colors.white,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              if (bestFriendText != null) ...[
                const SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 110),
                  child: Text(
                    bestFriendText!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              IconButton(
                onPressed: onPressed,
                icon: const Icon(
                  Icons.arrow_forward,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 1,
            color: Colors.grey,
            indent: 2,
            endIndent: 2,
          ),
        ],
      ),
    );
  }
}
