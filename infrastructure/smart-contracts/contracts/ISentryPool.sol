/**
 * @title Interface for SentryPool Contract
 * @dev Interface to define the functions of SentryPool contract, this is meant to provide a standard to be built from for different types of pools to be created
 */
interface ISentryPool {

    /**
     * @dev Function to get the name of the pool
     * @return The name of the pool
     */
    function getPoolName() external view returns (string memory);

    /**
     * @dev Function to deposit funds into the pool. The pool acts as a proxy, 
     * tracking the amount each user deposits based on the pool's settings.
     * @param amount The amount to be deposited by the user
     */
    function deposit(uint256 amount) external;

    /**
     * @dev Function to withdraw funds from the pool. The withdrawal is based on 
     * the amount the user has deposited and the pool's settings.
     * @param amount The amount to be withdrawn by the user
     */
    function withdraw(uint256 amount) external;

    /**
     * @dev Function to get the total balance of the pool
     * @return The total balance of the pool
     */
    function getTotalBalance() external view returns (uint256);

    /**
     * @dev Function to get the balance of a specific user
     * @param user The address of the user
     * @return The balance of the user
     */
    function getUserBalance(address user) external view returns (uint256);

    /**
     * @dev Function to get the address of a staker at a specific index
     * @param index The index of the staker in the list
     * @return The address of the staker at the given index
     */
    function getStakerAtIndex(uint256 index) external view returns (address);

    /**
     * @dev Function to get the total count of stakers in the pool
     * @return The total number of stakers
     */
    function getStakerCount() external view returns (uint256);

    /**
     * @dev Function to approve a wallet to be allowed to deposit
     * @param wallet The address of the wallet to be approved
     */
    function approveWallet(address wallet) external;

    /**
     * @dev Function to check if a wallet is approved to deposit
     * @param wallet The address of the wallet to be checked
     * @return A boolean indicating if the wallet is approved
     */
    function isWalletApproved(address wallet) external view returns (bool);

    /**
     * @dev Function to forcibly remove a user from the pool by an admin. This will also trigger
     * a withdrawal of all the user's funds in the pool to the user.
     * @param user The address of the user to be removed
     */
    function kickAndWithdraw(address user) external;

    /**
     * @dev Function to check if a user is an admin
     * @param user The address of the user to be checked
     * @return A boolean indicating if the user is an admin
     */
    function isAdmin(address user) external view returns (bool);
}
