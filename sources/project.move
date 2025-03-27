module SportsTrainingPlatform::Training {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    struct TrainingSession has store, key {
        total_staked: u64,
        reward_pool: u64,
    }

    public fun stake_tokens(user: &signer, trainer: address, amount: u64) acquires TrainingSession {
        let session = borrow_global_mut<TrainingSession>(trainer);

        let stake = coin::withdraw<AptosCoin>(user, amount);
        coin::deposit<AptosCoin>(trainer, stake);

        session.total_staked = session.total_staked + amount;
    }

    public fun claim_rewards(trainer: &signer) acquires TrainingSession {
        let session = borrow_global_mut<TrainingSession>(signer::address_of(trainer));
        let reward = session.reward_pool;
        session.reward_pool = 0;

        let reward_coin = coin::withdraw<AptosCoin>(trainer, reward);
        coin::deposit<AptosCoin>(signer::address_of(trainer), reward_coin);
    }
}
