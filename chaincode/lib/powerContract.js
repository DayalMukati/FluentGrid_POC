"use strict";

const { Contract } = require("fabric-contract-api");

class PowerContract extends Contract {
    //Init function
    async InitLedger() {
        console.log("Power contract has been started");
    }

    //CreateData
    async CreateData(ctx, args) {
        const data = JSON.parse(args);
        data.LatestTransaction = ctx.stub.getTxID();
        // === Save asset to state ===
        console.log(JSON.stringify(data));
        await ctx.stub.putState(data.id, Buffer.from(JSON.stringify(data)));
        return data;
    }
    //Update Function
    async UpdateData(ctx, args) {
        const data = JSON.parse(args);
        data.LatestTransaction = ctx.stub.getTxID();
        console.log(data, "chaincode data");
        await ctx.stub.putState(data.id, Buffer.from(JSON.stringify(data)));
        const result = await ctx.stub.getState(data.id);
        const updatedData = JSON.parse(result.toString());
        return updatedData;
    }
    //Getter Functions
    async FindOne(ctx, query = {}, docType) {
        const queryData = JSON.parse(query);
        const queryString = {
            selector: {
                ...queryData,
                docType,
            },
        };
        const data = await this.GetQueryResultForQueryString(
            ctx,
            JSON.stringify(queryString)
        );
        const data1 = JSON.stringify(Array.from(new Int32Array(data)));
        return data1;
    }

    async Find(ctx, query = {}, docType) {
        const queryData = JSON.parse(query);
        const queryString = {
            selector: {
                ...queryData,
                docType,
            },
        };
        console.log({
            queryString,
        });
        return await this.GetQueryResultForQueryString(
            ctx,
            JSON.stringify(queryString)
        );
    }
    //Get by Id
    async GetbyId(ctx, id, docType) {
        let queryString = {};
        queryString.selector = {};
        queryString.selector.docType = docType;
        queryString.selector.id = id;
        return await this.GetQueryResultForQueryString(
            ctx,
            JSON.stringify(queryString)
        ); //shim.success(queryResults);
    }

    //Get All Records
    async GetAll(ctx, docType) {
        let queryString = {};
        queryString.selector = {};
        queryString.selector.docType = docType;
        console.log(queryString, "line 127");
        return await this.GetQueryResultForQueryString(
            ctx,
            JSON.stringify(queryString)
        );
    }
    async GetQueryResultForQueryString(ctx, queryString) {
        let resultsIterator = await ctx.stub.getQueryResult(queryString);
        let results = await this.GetAllResults(resultsIterator, false);

        return JSON.stringify(results);
    }

    async GetAllResults(iterator, isHistory) {
        let allResults = [];
        let res = await iterator.next();
        while (!res.done) {
            if (res.value && res.value.value.toString()) {
                let jsonRes = {};
                console.log(res.value.value.toString("utf8"));
                if (isHistory && isHistory === true) {
                    jsonRes.TxId = res.value.tx_id;
                    jsonRes.Timestamp = res.value.timestamp;
                    try {
                        jsonRes.Value = JSON.parse(
                            res.value.value.toString("utf8")
                        );
                    } catch (err) {
                        console.log(err);
                        jsonRes.Value = res.value.value.toString("utf8");
                    }
                } else {
                    jsonRes = JSON.parse(res.value.value.toString("utf8"));
                    // jsonRes.Key = res.value.key;
                    // try {
                    // 	jsonRes.Record = JSON.parse(res.value.value.toString('utf8'));
                    // } catch (err) {
                    // 	console.log(err);
                    // 	jsonRes.Record = res.value.value.toString('utf8');
                    // }
                }
                allResults.push(jsonRes);
            }
            res = await iterator.next();
        }
        iterator.close();
        return allResults;
    }

    // async createOrgwallet(ctx, args) {
    //     let data = JSON.parse(args);
    //     const organizationName = data.organizationName;
    //     const walletId = data.id;
    //     let wallet = {
    //         docType: "Wallet",
    //         id: walletId,
    //         orgType: data.orgType,
    //         organizationName: data.organizationName,
    //         source: data.source,
    //         transactionDate: data.transactionDate,
    //         transactionNumber: data.transactionNumber,
    //         transactionType: data.transactionType,
    //         transactionAmount: data.transactionAmount,
    //         totalBalance: data.totalBalance,
    //     };
    //     const queryString = {
    //         selector: {
    //             organizationName,
    //             docType,
    //         },
    //     };
    //     const duplicateWallet = this.GetQueryResultForQueryString(
    //         ctx,
    //         JSON.stringify(queryString)
    //     );
    //     if (!duplicateWallet) {
    //         data.LatestTransaction = ctx.stub.getTxID();
    //         // === Save asset to state ===
    //         console.log(JSON.stringify(data));
    //         await ctx.stub.putState(data.id, Buffer.from(JSON.stringify(data)));
    //         return data;
    //     } else {
    //         throw new Error(`${organizationName} already exist`); 
    //     }
    // }
}
module.exports = PowerContract;
