// Copyright (C) 2021  Argent Labs Ltd. <https://argent.xyz>

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.3;

import "../BaseFilter.sol";

/**
 * @title CurveFilter
 * @notice Filter used for calls to every supported Curve exchange (pool), e.g. 0x45f783cce6b7ff23b2ab2d70e416cdb7d6055f51
 * @author Olivier VDB - <olivier@argent.xyz>
 */
contract CurveFilter is BaseFilter {

    bytes4 private constant EXCHANGE = bytes4(keccak256("exchange(int128,int128,uint256,uint256)"));
    bytes4 private constant EXCHANGE_UNDERLYING = bytes4(keccak256("exchange_underlying(int128,int128,uint256,uint256)"));
    bytes4 private constant ERC20_APPROVE = bytes4(keccak256("approve(address,uint256)"));

    function isValid(address /*_wallet*/, address _spender, address _to, bytes calldata _data) external view override returns (bool valid) {
        // disable ETH transfer
        if (_data.length < 4) {
            return false;
        }

        bytes4 methodId = getMethod(_data);

        return (methodId == ERC20_APPROVE && _spender != _to) || methodId == EXCHANGE || methodId == EXCHANGE_UNDERLYING;
    }
}