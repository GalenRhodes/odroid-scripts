/***************************************************************************//**
 *     PROJECT: NiagraFalls
 *    FILENAME: NFMyObject.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 3/30/16 12:31 PM
 * DESCRIPTION:
 *
 * Copyright © 2016 Project Galen. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *******************************************************************************/

#import "NFMyObject.h"

int main(int argc, char *const argv[]) {
	NFMyObject *obj = [[NFMyObject alloc] initWithNumerator:2 andDenominator:3];
	NSLog(@"Description: %@", obj);
	NSLog(@"     Result: %@", @([obj result]));
	return 0;
}
