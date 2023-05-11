// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./SafeMath.sol";
import "./Context.sol";
import "./Ownable.sol";

contract ERC20 is Context , Ownable , IERC20
    {

        using SafeMath for uint256;

        mapping (address => uint256) _balances;
        mapping (address => mapping(address => uint256)) _allowance;

        uint private _totalSupply;
        uint private _decimals;

        string private _name;
        string private _symbol;


        constructor (string memory name_ , string memory symbol_ , uint totalSupply_ , uint decimals_)
        {
            _name = name_;
            _symbol = symbol_;
            _totalSupply = totalSupply_;
            _decimals = decimals_;
        }


        function name () public view virtual returns (string memory)
        {
            return _name;
        }

        function symbol () public view virtual returns (string memory)
        {
            return _symbol;
        }

        function decimals () public view virtual returns (uint)
        {
            return _decimals;
        }

        function totalSupply () public view virtual override returns (uint)
        {
            return _totalSupply;
        }


        function balanceOf (address account) public view virtual override returns (uint256)
        {
            return _balances[account];
        }

            /*
            * function Token burning
    *- The function is called "_transfer" and is an internal virtual override, which means it can only be accessed within the contract and can be overridden by child contracts.
    *- The first three lines are require statements that check if the sender, recipient, and transfer amount are valid. If any of these checks fail, the function will revert.
    *- The if statement checks if the transfer amount is greater than or equal to 100. If it is, then the transfer will trigger a burn of 0.5% of the transfer amount, and the remaining amount will be transferred to the recipient. If the transfer amount is less than 100, then the full transfer amount will be transferred to the recipient.
    *- The burn amount is calculated by multiplying the transfer amount by 5 and then dividing by 1000. This results in a burn of 0.5% of the transfer amount.
    *- The _burn function is called to burn the calculated burn amount from the sender's balance.
    *- The _beforeTokenTransfer function is called before the transfer takes place, which allows for additional checks or actions to be taken.
    *- The sender's balance is decreased by the transfer amount (including the burn amount), and the recipient's balance is increased by the transfer amount (minus the burn amount).
    *- An event is emitted to indicate that the transfer has taken place.
    *- The _afterTokenTransfer function is called after the transfer takes place, which allows for additional checks or actions to be taken.
            */
            function _transfer(address sender, address recipient, uint256 amount) internal virtual  { 
            require(sender != address(0), "ERC20: transfer from the zero address");
            require(recipient != address(0), "ERC20: transfer to the zero address");
            require(amount > 0, "ERC20: transfer amount must be greater than zero");

            if (amount >= 100) {
            uint256 burnAmount = amount * 5 / 1000;
            uint256 transferAmount = amount - burnAmount;

            _burn(sender, burnAmount);
            _beforeTokenTransfer(sender, recipient, transferAmount);

            _balances[sender] -= amount;
            _balances[recipient] += transferAmount;

            emit Transfer(sender, recipient, transferAmount);

            _afterTokenTransfer(sender, recipient, transferAmount);
            } else {
            _beforeTokenTransfer(sender, recipient, amount);

            _balances[sender] -= amount;
            _balances[recipient] += amount;

            emit Transfer(sender, recipient, amount);

            _afterTokenTransfer(sender, recipient, amount); 
            }
            }

                    // mint function

                     function _mint(address account, uint256 amount) internal virtual {
                     require(account != address(0), "ERC20: mint to the zero address");

                    _beforeTokenTransfer(address(0), account, amount);

                    _totalSupply += amount;
                    unchecked {
                    // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
                    _balances[account] += amount;
                    }
                    emit Transfer(address(0), account, amount);

                    _afterTokenTransfer(address(0), account, amount);
                        }

                        // burn function 

                        function _burn(address account, uint256 amount) internal virtual {
                        require(account != address(0), "ERC20: burn from the zero address");

                        _beforeTokenTransfer(account, address(0), amount);

                        uint256 accountBalance = _balances[account];
                        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
                        unchecked {
                        _balances[account] = accountBalance - amount;
                         // Overflow not possible: amount <= accountBalance <= totalSupply.
                        _totalSupply -= amount;
                            }

                        emit Transfer(account, address(0), amount);

                        _afterTokenTransfer(account, address(0), amount);
                             }

                function _approve (address owner , address spender , uint256 amount) internal virtual
                {
                    require(owner != address(0) ,  "ERC20: approve from the zero address");
                    require(spender != address(0) , "ERC20: approve spender the zero address");

                    _allowance[owner][spender] = amount;

                    emit Approval (owner , spender , amount);
                }

         function transfer 
         (
            address to,
            uint256 amount
         )
         public  virtual override returns (bool)
         {
            address from =  _msgSender();
            _transfer(from , to , amount);

            return true;
         }


        function allowance (address owner , address spender) public view virtual override returns (uint256)
        {
            return _allowance[owner][spender];
        }


        function approve (address spender , uint256 amount) public virtual override returns (bool)
        {
            address owner =  _msgSender();
            _approve(owner , spender , amount);

            return true;

        }

      
        function transferFrom (address from , address to , uint256 amount) public virtual override returns (bool)
        {
            address spender =  _msgSender();
            require(amount <= _allowance[from][spender]);
            _allowance[from][spender] =  _allowance[from][spender].sub(amount);

            _transfer(from , to , amount);

            return true;
        }

         function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}

         function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {} 

    }
