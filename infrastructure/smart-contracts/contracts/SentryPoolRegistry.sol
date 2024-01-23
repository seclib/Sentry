// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "./ISentryPool.sol";

/**
 * @title SentryPoolRegistry
 * @dev Implementation of the SentryPoolRegistry that keeps a registry of all the ISentryPool contracts.
 * Allows pool owners to add or remove their pools, and admins to approve pools.
 */
contract SentryPoolRegistry is Initializable, AccessControlUpgradeable {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    // EnumerableSet to store pool addresses
    EnumerableSetUpgradeable.AddressSet private poolSet;

    // Mapping from pool address to admin approval status
    mapping(address => bool) public approvedPools;

    event PoolAdded(address indexed pool);
    event PoolRemoved(address indexed pool);
    event PoolApproved(address indexed pool);
    event PoolDisapproved(address indexed pool);

    function initialize() public initializer {
        __AccessControl_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setRoleAdmin(ADMIN_ROLE, DEFAULT_ADMIN_ROLE);
    }

    /**
     * @dev Function to add a pool to the registry by the pool owner
     * @param pool The address of the pool.
     */
    function addPool(address pool) public {
        require(pool != address(0), "Pool address cannot be 0");
        require(ISentryPool(pool).isAdmin(msg.sender), "Not pool admin");
        require(!poolSet.contains(pool), "Pool already added");

        poolSet.add(pool);

        emit PoolAdded(pool);
    }

    /**
     * @dev Function to remove a pool from the registry by the pool owner
     * @param pool The address of the pool.
     */
    function removePool(address pool) public {
        require(pool != address(0), "Pool address cannot be 0");
        require(ISentryPool(pool).isAdmin(msg.sender), "Not pool admin");
        require(poolSet.contains(pool), "Pool not found");

        poolSet.remove(pool);

        emit PoolRemoved(pool);
    }

    /**
     * @dev Function for an admin to approve a pool
     * @param pool The address of the pool.
     */
    function approvePool(address pool) public onlyRole(ADMIN_ROLE) {
        require(pool != address(0), "Pool address cannot be 0");
        require(poolSet.contains(pool), "Pool not found");

        approvedPools[pool] = true;

        emit PoolApproved(pool);
    }

    /**
     * @dev Function for an admin to disapprove a pool
     * @param pool The address of the pool.
     */
    function disapprovePool(address pool) public onlyRole(ADMIN_ROLE) {
        require(pool != address(0), "Pool address cannot be 0");
        require(poolSet.contains(pool), "Pool not found");

        approvedPools[pool] = false;

        emit PoolDisapproved(pool);
    }

    /**
     * @dev Function to check if a pool is in the registry
     * @param pool The address of the pool.
     * @return A boolean indicating if the pool is in the registry
     */
    function isPool(address pool) public view returns (bool) {
        return poolSet.contains(pool);
    }

    /**
     * @dev Function to check if a pool is approved by an admin
     * @param pool The address of the pool.
     * @return A boolean indicating if the pool is approved
     */
    function isPoolApproved(address pool) public view returns (bool) {
        return approvedPools[pool];
    }

    /**
     * @dev Function to get the pool address at a given index
     * @param index The index of the pool to query.
     * @return The address of the pool.
     */
    function getPoolAtIndex(uint256 index) public view returns (address) {
        require(index < getPoolCount(), "Index out of bounds");
        return poolSet.at(index);
    }

    /**
     * @dev Function to get the count of pools.
     * @return The count of pools.
     */
    function getPoolCount() public view returns (uint256) {
        return poolSet.length();
    }
}

